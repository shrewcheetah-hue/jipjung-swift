import SpriteKit
import UIKit

// 업장소멸(業障消滅) 모드 SpriteKit 씬
// 탭할 때마다 붉은 불꽃과 불씨가 사방으로 퍼짐
final class KarmaParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    // 탭 위치에서 불꽃 파티클 방출
    func burst(at point: CGPoint) {
        // 폭발 섬광 (붉은빛)
        let flash = SKShapeNode(circleOfRadius: 55)
        flash.fillColor = UIColor(red: 0.95, green: 0.35, blue: 0.10, alpha: 0.6)
        flash.strokeColor = UIColor(red: 1.0, green: 0.65, blue: 0.20, alpha: 0.8)
        flash.lineWidth = 2
        flash.position = point
        flash.blendMode = .add
        addChild(flash)
        flash.run(.sequence([
            .group([
                .scale(to: 2.5, duration: 0.15),
                .sequence([.wait(forDuration: 0.05), .fadeOut(withDuration: 0.15)])
            ]),
            .removeFromParent()
        ]))

        // 불꽃 입자 50개 (사방으로 퍼짐)
        for _ in 0..<50 {
            spawnEmber(at: point)
        }

        // 큰 불꽃 8개 (위로 솟구침)
        for _ in 0..<8 {
            spawnFlame(at: point)
        }

        // 연기 4개
        for _ in 0..<4 {
            spawnSmoke(at: point)
        }
    }

    private func spawnEmber(at origin: CGPoint) {
        let size = CGFloat.random(in: 2...7)
        let node = SKShapeNode(circleOfRadius: size)

        // 빨강~주황~노랑 랜덤
        let t = CGFloat.random(in: 0...1)
        node.fillColor = UIColor(
            red: 1.0,
            green: 0.25 + t * 0.55,
            blue: t * 0.15,
            alpha: 1.0
        )
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = origin

        addChild(node)

        // 전방향으로 퍼짐
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let speed = CGFloat.random(in: 60...280)
        let dx = cos(angle) * speed
        let dy = sin(angle) * speed

        let duration = Double.random(in: 0.4...1.2)
        // 중력 효과 (아래로 떨어짐)
        let gravity = SKAction.moveBy(x: 0, y: -CGFloat.random(in: 30...80), duration: duration)
        let move = SKAction.moveBy(x: dx, y: dy, duration: duration)
        let combined = SKAction.group([move, gravity])
        let fade = SKAction.sequence([
            .wait(forDuration: duration * 0.3),
            .fadeOut(withDuration: duration * 0.7)
        ])
        let shrink = SKAction.scale(to: 0.1, duration: duration)

        node.run(.sequence([
            .group([combined, fade, shrink]),
            .removeFromParent()
        ]))
    }

    private func spawnFlame(at origin: CGPoint) {
        // 위로 솟구치는 불꽃 (타원형)
        let w = CGFloat.random(in: 6...14)
        let h = CGFloat.random(in: 16...32)
        let node = SKShapeNode(ellipseOf: CGSize(width: w, height: h))

        node.fillColor = UIColor(red: 1.0, green: CGFloat.random(in: 0.4...0.7), blue: 0.05, alpha: 0.85)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -30...30),
            y: origin.y
        )
        node.zRotation = CGFloat.random(in: -.pi/6 ... .pi/6)

        addChild(node)

        let duration = Double.random(in: 0.6...1.4)
        let riseHeight = CGFloat.random(in: 80...200)
        let drift = CGFloat.random(in: -20...20)

        let move = SKAction.moveBy(x: drift, y: riseHeight, duration: duration)
        let taper = SKAction.scaleX(to: 0.2, y: 0.1, duration: duration)
        let fade = SKAction.sequence([
            .wait(forDuration: duration * 0.4),
            .fadeOut(withDuration: duration * 0.6)
        ])
        let wobble = SKAction.sequence([
            .rotate(byAngle: 0.15, duration: 0.12),
            .rotate(byAngle: -0.15, duration: 0.12)
        ])

        node.run(.sequence([
            .group([move, taper, fade, .repeat(wobble, count: 6)]),
            .removeFromParent()
        ]))
    }

    private func spawnSmoke(at origin: CGPoint) {
        let size = CGFloat.random(in: 12...24)
        let node = SKShapeNode(circleOfRadius: size)
        node.fillColor = UIColor(white: 0.4, alpha: 0.25)
        node.strokeColor = .clear
        node.blendMode = .alpha
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -20...20),
            y: origin.y + CGFloat.random(in: 0...20)
        )

        addChild(node)

        let duration = Double.random(in: 1.0...2.0)
        let rise = SKAction.moveBy(x: CGFloat.random(in: -15...15), y: CGFloat.random(in: 60...120), duration: duration)
        let expand = SKAction.scale(to: CGFloat.random(in: 2.5...4.0), duration: duration)
        let fade = SKAction.sequence([
            .wait(forDuration: duration * 0.3),
            .fadeOut(withDuration: duration * 0.7)
        ])

        node.run(.sequence([
            .group([rise, expand, fade]),
            .removeFromParent()
        ]))
    }
}
