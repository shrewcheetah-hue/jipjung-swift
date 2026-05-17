import SpriteKit
import UIKit

// 업장소멸(業障消滅) 모드 SpriteKit 씬
// 탭할 때 붉은 빛이 조용히 타오르며 사라지는 효과 — 무거운 업장이 소멸되는 느낌
final class KarmaParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    func burst(at point: CGPoint) {
        // 중앙 붉은 빛 번짐
        spawnGlow(at: point, radius: 25, maxRadius: 110,
                  color: UIColor(red: 0.90, green: 0.30, blue: 0.08, alpha: 0.50),
                  duration: 0.8)

        // 주황빛 외곽 번짐
        spawnGlow(at: point, radius: 18, maxRadius: 190,
                  color: UIColor(red: 0.95, green: 0.55, blue: 0.15, alpha: 0.15),
                  duration: 1.3)

        // 작은 불씨 몇 개 — 위로 천천히 사라짐
        for _ in 0..<5 {
            spawnEmber(at: point)
        }
    }

    // 흐릿한 원이 퍼지며 사라지는 빛
    private func spawnGlow(at point: CGPoint, radius: CGFloat, maxRadius: CGFloat,
                           color: UIColor, duration: TimeInterval) {
        let node = SKShapeNode(circleOfRadius: radius)
        node.fillColor = color
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = point
        node.alpha = 0
        addChild(node)

        let scale = maxRadius / radius
        node.run(.sequence([
            .group([
                .sequence([
                    .fadeIn(withDuration: duration * 0.12),
                    .fadeOut(withDuration: duration * 0.88)
                ]),
                .scale(to: scale, duration: duration)
            ]),
            .removeFromParent()
        ]))
    }

    // 작은 불씨가 위로 천천히 떠오르며 꺼짐
    private func spawnEmber(at origin: CGPoint) {
        let size = CGFloat.random(in: 1.5...4.0)
        let node = SKShapeNode(circleOfRadius: size)

        // 빨강~주황 사이
        let t = CGFloat.random(in: 0...1)
        node.fillColor = UIColor(
            red: 1.0,
            green: 0.20 + t * 0.45,
            blue: 0.05,
            alpha: 0.9
        )
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -30...30),
            y: origin.y + CGFloat.random(in: -15...15)
        )
        addChild(node)

        let riseY = CGFloat.random(in: 50...120)
        let driftX = CGFloat.random(in: -10...10)
        let duration = Double.random(in: 1.0...2.0)

        node.run(.sequence([
            .group([
                .moveBy(x: driftX, y: riseY, duration: duration),
                .sequence([
                    .fadeIn(withDuration: duration * 0.1),
                    .fadeOut(withDuration: duration * 0.9)
                ]),
                .scale(to: 0.1, duration: duration)
            ]),
            .removeFromParent()
        ]))
    }
}
