import SpriteKit
import UIKit

// 공덕(功德) 모드 SpriteKit 씬
// 탭할 때마다 금빛 빛 입자가 위로 피어오름
final class MeritParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    // 탭 위치에서 금빛 파티클 방출
    func burst(at point: CGPoint) {
        // 큰 섬광 (탭 순간 번쩍임)
        let flash = SKShapeNode(circleOfRadius: 60)
        flash.fillColor = UIColor(red: 0.95, green: 0.85, blue: 0.45, alpha: 0.5)
        flash.strokeColor = .clear
        flash.position = point
        flash.blendMode = .add
        addChild(flash)
        flash.run(.sequence([
            .scale(to: 2.0, duration: 0.12),
            .fadeOut(withDuration: 0.18),
            .removeFromParent()
        ]))

        // 금빛 빛 입자 40개 방출
        for _ in 0..<40 {
            spawnGoldParticle(at: point)
        }

        // 연꽃잎 모양 큰 입자 6개
        for _ in 0..<6 {
            spawnLotusParticle(at: point)
        }
    }

    private func spawnGoldParticle(at origin: CGPoint) {
        let size = CGFloat.random(in: 3...9)
        let node = SKShapeNode(circleOfRadius: size)

        // 금빛 ~ 흰빛 랜덤
        let brightness = CGFloat.random(in: 0.7...1.0)
        node.fillColor = UIColor(red: brightness, green: brightness * 0.88, blue: brightness * 0.45, alpha: 1.0)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = origin

        addChild(node)

        // 위쪽으로 퍼지는 방향 (약간 랜덤)
        let angle = CGFloat.random(in: .pi * 0.15 ... .pi * 0.85)  // 위쪽 반원
        let speed = CGFloat.random(in: 80...220)
        let dx = cos(angle) * speed * CGFloat.random(in: 0.5...1.5) - speed * 0.5
        let dy = sin(angle) * speed

        let duration = Double.random(in: 0.8...1.8)
        let moveUp = SKAction.moveBy(x: dx, y: dy, duration: duration)
        let drift = SKAction.moveBy(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: 20...60), duration: duration * 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: duration * 0.6)
        let scale = SKAction.scale(to: CGFloat.random(in: 0.1...0.4), duration: duration)

        node.run(.sequence([
            .group([moveUp, .sequence([.wait(forDuration: duration * 0.4), fadeOut]), scale]),
            .removeFromParent()
        ]))
    }

    private func spawnLotusParticle(at origin: CGPoint) {
        // 마름모 모양으로 연꽃잎 표현
        let path = UIBezierPath()
        let s = CGFloat.random(in: 6...14)
        path.move(to: CGPoint(x: 0, y: s * 2))
        path.addLine(to: CGPoint(x: s, y: 0))
        path.addLine(to: CGPoint(x: 0, y: -s * 0.5))
        path.addLine(to: CGPoint(x: -s, y: 0))
        path.close()

        let node = SKShapeNode(path: path.cgPath)
        node.fillColor = UIColor(red: 0.98, green: 0.92, blue: 0.65, alpha: 0.9)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = origin
        node.zRotation = CGFloat.random(in: 0...(2 * .pi))

        addChild(node)

        let angle = CGFloat.random(in: .pi * 0.1 ... .pi * 0.9)
        let speed = CGFloat.random(in: 60...160)
        let dx = cos(angle) * speed - speed * 0.3
        let dy = sin(angle) * speed + 40

        let duration = Double.random(in: 1.2...2.2)
        let spin = SKAction.rotate(byAngle: CGFloat.random(in: -.pi...(.pi)), duration: duration)
        let move = SKAction.moveBy(x: dx, y: dy, duration: duration)
        let fade = SKAction.sequence([
            .wait(forDuration: duration * 0.5),
            .fadeOut(withDuration: duration * 0.5)
        ])

        node.run(.sequence([
            .group([move, spin, fade]),
            .removeFromParent()
        ]))
    }
}
