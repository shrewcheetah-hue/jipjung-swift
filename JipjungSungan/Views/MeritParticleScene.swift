import SpriteKit
import UIKit

// 공덕(功德) 모드 SpriteKit 씬
// 탭할 때 연꽃이 하나씩 뿜어져 나와 위로 떠오르며 사라짐
final class MeritParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    func burst(at point: CGPoint) {
        // 은은한 빛 번짐 (배경 효과)
        spawnGlow(at: point)

        // 연꽃 2~3개 뿜어져 나옴
        let count = Int.random(in: 2...3)
        for i in 0..<count {
            let delay = Double(i) * 0.08
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.spawnLotus(at: point)
            }
        }
    }

    // 은은한 금빛/핑크빛 빛 번짐
    private func spawnGlow(at point: CGPoint) {
        let node = SKShapeNode(circleOfRadius: 20)
        node.fillColor = UIColor(red: 0.98, green: 0.80, blue: 0.85, alpha: 0.35)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = point
        node.alpha = 0
        addChild(node)

        node.run(.sequence([
            .group([
                .sequence([.fadeIn(withDuration: 0.1), .fadeOut(withDuration: 0.7)]),
                .scale(to: 7.0, duration: 0.8)
            ]),
            .removeFromParent()
        ]))
    }

    // 연꽃 이미지 하나가 중앙에서 나와 위로 떠오르며 사라짐
    private func spawnLotus(at origin: CGPoint) {
        let node = SKSpriteNode(imageNamed: "lotus")

        // 크기: 레퍼런스처럼 다양한 크기
        let baseSize = CGFloat.random(in: 28...60)
        node.size = CGSize(width: baseSize, height: baseSize)

        // 시작 위치: 목탁 중앙 근처에서 약간 랜덤하게
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -25...25),
            y: origin.y + CGFloat.random(in: -15...15)
        )

        // 초기 상태: 작게 시작
        node.setScale(0.3)
        node.alpha = 0
        node.zRotation = CGFloat.random(in: -.pi * 0.15 ... .pi * 0.15)

        addChild(node)

        // 이동 방향: 위쪽으로, 약간 좌우 흔들림
        let riseY = CGFloat.random(in: 180...380)
        let driftX = CGFloat.random(in: -50...50)
        let duration = Double.random(in: 1.8...3.0)

        // 살짝 회전하며 떠오름
        let spin = SKAction.rotate(byAngle: CGFloat.random(in: -.pi * 0.3 ... .pi * 0.3), duration: duration)

        // 크기: 나타날 때 커지고 사라질 때 다시 작아짐
        let growAndShrink = SKAction.sequence([
            .scale(to: 1.0, duration: duration * 0.25),
            .scale(to: CGFloat.random(in: 0.6...0.9), duration: duration * 0.75)
        ])

        // 페이드: 나타났다가 위쪽에서 서서히 사라짐
        let fade = SKAction.sequence([
            .fadeIn(withDuration: duration * 0.15),
            .wait(forDuration: duration * 0.5),
            .fadeOut(withDuration: duration * 0.35)
        ])

        let move = SKAction.moveBy(x: driftX, y: riseY, duration: duration)

        node.run(.sequence([
            .group([move, spin, growAndShrink, fade]),
            .removeFromParent()
        ]))
    }
}
