import SwiftUI
import AppKit

@main
struct GroupMakerApp: App {
    var body: some Scene {
        WindowGroup("ランダムグループ分け") {
            ContentView()
                .frame(minWidth: 520, minHeight: 560)
        }
    }
}

struct ContentView: View {
    @State private var namesText: String = ""
    @State private var groupCount: Int = 2
    @State private var groups: [[String]] = []
    @State private var errorMessage: String?

    private var names: [String] {
        // 半角・全角コンマ、読点、改行で区切る
        namesText
            .components(separatedBy: CharacterSet(charactersIn: ",，、\n"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("名前リスト（コンマ区切り）")
                .font(.headline)
            TextEditor(text: $namesText)
                .font(.body)
                .frame(minHeight: 110)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.secondary.opacity(0.4)))
            Text("\(names.count) 人")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack {
                Text("グループ数")
                    .font(.headline)
                TextField("", value: $groupCount, format: .number)
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)
                Stepper("", value: $groupCount, in: 1...999)
                    .labelsHidden()
                Spacer()
                Button("グループ分け") { makeGroups() }
                    .keyboardShortcut(.return, modifiers: .command)
                    .buttonStyle(.borderedProminent)
                Button("コピー") { copyResult() }
                    .disabled(groups.isEmpty)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Divider()

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)],
                          alignment: .leading, spacing: 12) {
                    ForEach(groups.indices, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("グループ \(i + 1)（\(groups[i].count)人）")
                                .font(.headline)
                            ForEach(groups[i], id: \.self) { name in
                                Text("・\(name)")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor.opacity(0.12)))
                        .textSelection(.enabled)
                    }
                }
            }
        }
        .padding(18)
    }

    private func makeGroups() {
        let list = names
        errorMessage = nil
        guard !list.isEmpty else {
            errorMessage = "名前を入力してください。"
            groups = []
            return
        }
        guard groupCount >= 1 else {
            errorMessage = "グループ数は1以上にしてください。"
            return
        }
        if groupCount > list.count {
            errorMessage = "グループ数が人数より多いため、空のグループがあります。"
        }
        // SystemRandomNumberGenerator（暗号学的乱数）でシャッフルし、順に配る
        var rng = SystemRandomNumberGenerator()
        let shuffled = list.shuffled(using: &rng)
        var result = Array(repeating: [String](), count: groupCount)
        for (i, name) in shuffled.enumerated() {
            result[i % groupCount].append(name)
        }
        groups = result
    }

    private func copyResult() {
        let text = groups.enumerated().map { i, g in
            "グループ \(i + 1): " + g.joined(separator: ", ")
        }.joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }
}
