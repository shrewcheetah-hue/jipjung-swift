import SpriteKit
import UIKit

// 업장소멸(業障消滅) 모드 SpriteKit 씬
// 탭할 때 불꽃 업장 캐릭터가 하나씩 뿜어져 나와 흩어지며 사라짐
final class KarmaParticleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .clear
        scaleMode = .resizeFill
    }

    func burst(at point: CGPoint) {
        // 붉은 빛 번짐 (배경 효과)
        spawnGlow(at: point)

        // 불꽃 캐릭터 2~3개 뿜어져 나옴
        let count = Int.random(in: 2...3)
        for i in 0..<count {
            let delay = Double(i) * 0.07
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.spawnFlameCharacter(at: point)
            }
        }
    }

    // 붉은 빛 번짐
    private func spawnGlow(at point: CGPoint) {
        let node = SKShapeNode(circleOfRadius: 20)
        node.fillColor = UIColor(red: 0.90, green: 0.30, blue: 0.08, alpha: 0.40)
        node.strokeColor = .clear
        node.blendMode = .add
        node.position = point
        node.alpha = 0
        addChild(node)

        node.run(.sequence([
            .group([
                .sequence([.fadeIn(withDuration: 0.08), .fadeOut(withDuration: 0.65)]),
                .scale(to: 6.5, duration: 0.73)
            ]),
            .removeFromParent()
        ]))
    }

    // 불꽃 캐릭터 이미지가 중앙에서 나와 사방으로 흩어지며 사라짐
    private func spawnFlameCharacter(at origin: CGPoint) {
        let node = SKSpriteNode(imageNamed: "karma_flame")

        // 크기: 레퍼런스처럼 다양한 크기
        let baseSize = CGFloat.random(in: 32...65)
        node.size = CGSize(width: baseSize, height: baseSize)

        // 시작 위치: 목탁 중앙 근처
        node.position = CGPoint(
            x: origin.x + CGFloat.random(in: -20...20),
            y: origin.y + CGFloat.random(in: -15...15)
        )

        node.setScale(0.2)
        node.alpha = 0

        // 약간 기울어진 채로 시작
        node.zRotation = CGFloat.random(in: -.pi * 0.1 ... .pi * 0.1)

        addChild(node)

        // 이동: 위로 솟구치며 좌우로 흩어짐
        let riseY = CGFloat.random(in: 150...320)
        let driftX = CGFloat.random(in: -80...80)
        let duration = Double.random(in: 1.6...2.6)

        // 통통 튀는 느낌의 크기 변화
        let bounce = SKAction.sequence([
            .scale(to: 1.1, duration: duration * 0.2),
            .scale(to: 0.9, duration: duration * 0.1),
            .scale(to: CGFloat.random(in: 0.5...0.8), duration: duration * 0.7)
        ])

        // 살짝 흔들리며 올라감
        let wobble = SKAction.sequence([
            .rotate(byAngle: 0.12, duration: 0.18),
            .rotate(byAngle: -0.12, duration: 0.18)
        ])

        // 페이드
        let fade = SKAction.sequence([
            .fadeIn(withDuration: duration * 0.12),
            .wait(forDuration: duration * 0.45),
            .fadeOut(withDuration: duration * 0.43)
        ])

        let move = SKAction.moveBy(x: driftX, y: riseY, duration: duration)

        node.run(.sequence([
            .group([
                move,
                bounce,
                fade,
                .repeat(wobble, count: Int(duration / 0.36))
            ]),
            .removeFromParent()
        ]))
    }
}
