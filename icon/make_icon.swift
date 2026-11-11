// アプリアイコン (1024x1024 PNG) を描画する
// 使い方: swift icon/make_icon.swift icon/icon_1024.png
import AppKit

let size: CGFloat = 1024
let outPath = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "icon_1024.png"

let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(size), pixelsHigh: Int(size),
                           bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                           colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

// 背景: macOS 風の角丸スクエア（余白 100px）
let inset: CGFloat = 100
let bgRect = NSRect(x: inset, y: inset, width: size - inset * 2, height: size - inset * 2)
let bgPath = NSBezierPath(roundedRect: bgRect, xRadius: 185, yRadius: 185)

// 影
let shadow = NSShadow()
shadow.shadowColor = NSColor.black.withAlphaComponent(0.25)
shadow.shadowOffset = NSSize(width: 0, height: -12)
shadow.shadowBlurRadius = 28
NSGraphicsContext.saveGraphicsState()
shadow.set()
NSColor.white.setFill()
bgPath.fill()
NSGraphicsContext.restoreGraphicsState()

let gradient = NSGradient(colors: [
    NSColor(calibratedRed: 0.36, green: 0.42, blue: 0.98, alpha: 1),
    NSColor(calibratedRed: 0.62, green: 0.33, blue: 0.93, alpha: 1),
])!
gradient.draw(in: bgPath, angle: -60)

// 3つのグループ（円）と、その中の人（ドット）
struct Group { let center: CGPoint; let color: NSColor; let count: Int }
let groups = [
    Group(center: CGPoint(x: 512, y: 660), color: NSColor(calibratedRed: 1.00, green: 0.80, blue: 0.25, alpha: 1), count: 3),
    Group(center: CGPoint(x: 345, y: 380), color: NSColor(calibratedRed: 0.30, green: 0.90, blue: 0.70, alpha: 1), count: 3),
    Group(center: CGPoint(x: 679, y: 380), color: NSColor(calibratedRed: 1.00, green: 0.47, blue: 0.55, alpha: 1), count: 3),
]
let groupRadius: CGFloat = 150
let dotRadius: CGFloat = 46

for g in groups {
    // グループの輪
    let ring = NSBezierPath(ovalIn: NSRect(x: g.center.x - groupRadius, y: g.center.y - groupRadius,
                                           width: groupRadius * 2, height: groupRadius * 2))
    NSColor.white.withAlphaComponent(0.18).setFill()
    ring.fill()
    NSColor.white.withAlphaComponent(0.85).setStroke()
    ring.lineWidth = 10
    ring.stroke()

    // 人（頭＋肩）を三角形に配置
    for i in 0..<g.count {
        let angle = CGFloat.pi / 2 + CGFloat(i) * 2 * .pi / CGFloat(g.count)
        let r: CGFloat = 70
        let p = CGPoint(x: g.center.x + cos(angle) * r, y: g.center.y + sin(angle) * r - 10)
        g.color.setFill()
        NSBezierPath(ovalIn: NSRect(x: p.x - dotRadius * 0.55, y: p.y + 4,
                                    width: dotRadius * 1.1, height: dotRadius * 1.1)).fill()
        NSBezierPath(roundedRect: NSRect(x: p.x - dotRadius * 0.85, y: p.y - dotRadius * 0.75,
                                         width: dotRadius * 1.7, height: dotRadius * 0.8),
                     xRadius: dotRadius * 0.4, yRadius: dotRadius * 0.4).fill()
    }
}

// 中央のサイコロ（ランダムの象徴）
let dieSize: CGFloat = 120
let dieRect = NSRect(x: 512 - dieSize / 2, y: 505 - dieSize / 2, width: dieSize, height: dieSize)
let die = NSBezierPath(roundedRect: dieRect, xRadius: 26, yRadius: 26)
NSGraphicsContext.saveGraphicsState()
let s2 = NSShadow()
s2.shadowColor = NSColor.black.withAlphaComponent(0.3)
s2.shadowOffset = NSSize(width: 0, height: -6)
s2.shadowBlurRadius = 12
s2.set()
NSColor.white.setFill()
die.fill()
NSGraphicsContext.restoreGraphicsState()
NSColor(calibratedRed: 0.45, green: 0.36, blue: 0.95, alpha: 1).setFill()
let pip: CGFloat = 22
for (dx, dy) in [(-30, 30), (0, 0), (30, -30)] as [(CGFloat, CGFloat)] {
    NSBezierPath(ovalIn: NSRect(x: dieRect.midX + dx - pip / 2, y: dieRect.midY + dy - pip / 2,
                                width: pip, height: pip)).fill()
}

NSGraphicsContext.restoreGraphicsState()
let data = rep.representation(using: .png, properties: [:])!
try! data.write(to: URL(fileURLWithPath: outPath))
print("Wrote \(outPath)")
