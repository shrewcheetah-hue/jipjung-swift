import SpriteKit
import UIKit

// 공덕(功德) 모드 SpriteKit 씬
// 탭할 때 은은한 금빛이 퍼지며 사라지는 효과 — 조용하고 따뜻한 느낌
final class MeritParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    func burst(at point: CGPoint) {
        // 중앙 빛 번짐 — 큰 흐릿한 원이 퍼졌다 사라짐
        spawnGlow(at: point, radius: 30, maxRadius: 120,
                  color: UIColor(red: 0.95, green: 0.82, blue: 0.40, alpha: 0.45),
                  duration: 0.9)

        // 더 넓게 퍼지는 외곽 빛
        spawnGlow(at: point, radius: 20, maxRadius: 200,
                  color: UIColor(red: 0.98, green: 0.90, blue: 0.55, alpha: 0.18),
                  duration: 1.4)

        // 작은 빛 점 몇 개 — 위로 천천히 떠오름
        for _ in 0..<6 {
            spawnDrift(at: point)
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
        // 흐릿하게
        node.alpha = 0
        addChild(node)

        let scale = maxRadius / radius
        node.run(.sequence([
            .group([
                .sequence([
                    .fadeIn(withDuration: duration * 0.15),
                    .fadeOut(withDuration: duration * 0.85)
                ]),
                .scale(to: scale, duration: duration)
            ]),
            .removeFromParent()
        ]))
    }

    // 작은 빛 점이 위로 천천히 떠오르며 사라짐
    private func spawnDrift(at origin: CGPoint) {
        let size = CGFloat.random(in: 2...5)
        let node = SKShapeNode(circleOfRadius: size)
        node.fillColor = UIColor(red: 0.98, green: 0.92, blue: 0.60, alpha: 0.8)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -40...40),
            y: origin.y + CGFloat.random(in: -20...20)
        )
        addChild(node)

        let riseY = CGFloat.random(in: 60...140)
        let driftX = CGFloat.random(in: -15...15)
        let duration = Double.random(in: 1.2...2.2)

        node.run(.sequence([
            .group([
                .moveBy(x: driftX, y: riseY, duration: duration),
                .sequence([
                    .fadeIn(withDuration: duration * 0.2),
                    .fadeOut(withDuration: duration * 0.8)
                ]),
                .scale(to: 0.2, duration: duration)
            ]),
            .removeFromParent()
        ]))
    }
}
