import SwiftUI

// 집중의 순간 - 수행 화면
// 디자인: 목탁 이미지 중앙, 수축하는 타이밍 링, HUD, 진급 진행바
// 가이드 빛: 박자마다 황금빛 플래시 (소리 없음)
// 4단계: 소리 없음

struct PracticeView: View {
    @ObservedObject var engine: RhythmEngine
    let stage: Int
    let onEnd: () -> Void

    @State private var showEndConfirm = false
    @State private var tapFlash = false
    @State private var hitFeedbackScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // 배경 - 단계에 따라 점점 어두워짐
            stageBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // HUD (상단)
                hudBar
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                Spacer()

                // 중앙 - 목탁 탭 영역 + 타이밍 링 (링이 목탁 위에)
                ZStack {
                    // 가이드 빛 플래시 (1~2단계) - 맨 아래
                    if engine.stageConfig.hasGuideLight {
                        guideFlash
                    }

                    // 목탁 탭 영역 (중간)
                    moktakTapArea

                    // 타이밍 링 (수축하는 원) - 목탁 위에 표시
                    if engine.stage < 5 {
                        timingRing
                    }
                }
                .frame(width: 360, height: 360)

                Spacer()

                // 진급 진행바 (5단계 제외)
                if engine.stage < 5 {
                    promoteBar
                        .padding(.horizontal, 28)
                        .padding(.bottom, 12)
                }

                // 히트 결과 피드백
                hitFeedback
                    .padding(.bottom, 8)

                // 종료 버튼
                endButton
                    .padding(.bottom, 40)
            }
        }
        .alert("수행을 종료하시겠습니까?", isPresented: $showEndConfirm) {
            Button("종료", role: .destructive) { onEnd() }
            Button("계속", role: .cancel) {}
        }
    }

    // MARK: - Background
    private var stageBackground: some View {
        let darkness = Double(engine.stage - 1) * 0.015
        return Color(
            red: max(0.08 - darkness, 0.03),
            green: max(0.07 - darkness, 0.02),
            blue: max(0.06 - darkness, 0.01)
        )
    }

    // MARK: - HUD
    private var hudBar: some View {
        HStack {
            // 시간
            VStack(alignment: .leading, spacing: 2) {
                Text(t.hudTime)
                    .font(.system(size: 10, weight: .light))
                    .foregroundColor(AppColors.white30)
                Text(engine.elapsedFormatted)
                    .font(.system(size: 16, weight: .thin, design: .monospaced))
                    .foregroundColor(AppColors.white80)
            }

            Spacer()

            // 단계 표시
            VStack(spacing: 2) {
                Text(t.stageNames[engine.stage - 1])
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.goldDim)
                Text("\(Int(engine.bpm)) BPM")
                    .font(.system(size: 13, weight: .thin, design: .monospaced))
                    .foregroundColor(AppColors.gold)
            }

            Spacer()

            // 오늘 / 연속
            VStack(alignment: .trailing, spacing: 2) {
                Text(t.hudToday)
                    .font(.system(size: 10, weight: .light))
                    .foregroundColor(AppColors.white30)
                Text(t.consecutive(engine.consecutiveHits))
                    .font(.system(size: 14, weight: .thin, design: .monospaced))
                    .foregroundColor(AppColors.white80)
            }
        }
    }

    // MARK: - Timing Ring
    private var timingRing: some View {
        let maxRadius: CGFloat = 175
        let minRadius: CGFloat = 65
        let currentRadius = maxRadius - (maxRadius - minRadius) * CGFloat(engine.ringProgress)

        return ZStack {
            // 수축하는 링
            Circle()
                .stroke(ringColor, lineWidth: 1.5)
                .frame(width: currentRadius * 2, height: currentRadius * 2)
                .opacity(0.6)

            // 중앙 고정 원 (타격 지점)
            Circle()
                .stroke(AppColors.goldAlpha30, lineWidth: 1)
                .frame(width: minRadius * 2, height: minRadius * 2)
        }
    }

    private var ringColor: Color {
        switch engine.lastHitResult {
        case .perfect: return AppColors.perfect
        case .near: return AppColors.near
        case .off: return AppColors.off
        case nil: return AppColors.goldDim
        }
    }

    // MARK: - Guide Flash
    private var guideFlash: some View {
        Circle()
            .fill(AppColors.gold)
            .frame(width: 200, height: 200)
            .opacity(engine.guideBeat ? 0.06 : 0)
            .animation(.easeOut(duration: 0.1), value: engine.guideBeat)
    }

    // MARK: - Moktak Tap Area
    private var moktakTapArea: some View {
        // 탭 횟수 기반 glow 강도 (0~1, 최대 30회)
        let glowIntensity = min(Double(engine.totalHits) / 30.0, 1.0)
        let glowRadius = 20.0 + glowIntensity * 60.0
        let glowOpacity = 0.15 + glowIntensity * 0.55

        return Button(action: {
            engine.onHit()
            withAnimation(.easeOut(duration: 0.08)) {
                tapFlash = true
                hitFeedbackScale = 0.94
            }
            withAnimation(.easeIn(duration: 0.15).delay(0.08)) {
                tapFlash = false
                hitFeedbackScale = 1.0
            }
        }) {
            ZStack {
                // 탭할수록 강해지는 뒤쪽 glow (황금빛 후광)
                Circle()
                    .fill(AppColors.gold)
                    .frame(width: 120, height: 120)
                    .blur(radius: glowRadius)
                    .opacity(glowOpacity)
                    .animation(.easeOut(duration: 0.3), value: engine.totalHits)

                // 탭 플래시 (순간 번쩍)
                Circle()
                    .fill(AppColors.gold)
                    .frame(width: 140, height: 140)
                    .blur(radius: 30)
                    .opacity(tapFlash ? 0.5 : 0)

                // 목탁 이미지
                if UIImage(named: "moktak") != nil {
                    Image("moktak")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .scaleEffect(hitFeedbackScale)
                } else {
                    // 폴백: 원형 목탁 심볼
                    ZStack {
                        Circle()
                            .fill(AppColors.surface)
                            .overlay(
                                Circle().stroke(AppColors.goldAlpha15, lineWidth: 1)
                            )
                            .frame(width: 200, height: 200)
                        Text("木鐸")
                            .font(.system(size: 40, weight: .thin))
                            .foregroundColor(AppColors.goldDim)
                    }
                    .scaleEffect(hitFeedbackScale)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Promote Bar
    private var promoteBar: some View {
        VStack(spacing: 6) {
            HStack {
                Text(t.promoteLabel(engine.promoteRemaining))
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white30)
                Spacer()
                Text("\(Int(engine.promoteProgress))/\(engine.stageConfig.promoteThreshold)")
                    .font(.system(size: 11, weight: .light, design: .monospaced))
                    .foregroundColor(AppColors.goldDim)
            }

            // 점 10개
            HStack(spacing: 8) {
                ForEach(0..<engine.stageConfig.promoteThreshold, id: \.self) { i in
                    Circle()
                        .fill(i < Int(engine.promoteProgress) ? AppColors.gold : AppColors.white10)
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut(duration: 0.2), value: engine.promoteProgress)
                }
            }
        }
    }

    // MARK: - Hit Feedback
    private var hitFeedback: some View {
        Group {
            if let result = engine.lastHitResult {
                Text(hitResultText(result))
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(hitResultColor(result))
                    .tracking(2)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: engine.lastHitResult)
            } else {
                Text(" ")
                    .font(.system(size: 14))
            }
        }
        .frame(height: 20)
    }

    private func hitResultText(_ result: HitResult) -> String {
        switch result {
        case .perfect: return "PERFECT"
        case .near: return "NEAR"
        case .off: return "OFF"
        }
    }

    private func hitResultColor(_ result: HitResult) -> Color {
        switch result {
        case .perfect: return AppColors.perfect
        case .near: return AppColors.near
        case .off: return AppColors.off
        }
    }

    // MARK: - End Button
    private var endButton: some View {
        Button(action: { showEndConfirm = true }) {
            Text(t.endButton)
                .font(.system(size: 13, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(1)
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.white10, lineWidth: 1)
                )
        }
    }
}

// stageConfig 접근 편의 extension
extension RhythmEngine {
    var stageConfig: StageConfig {
        stageConfigs[stage - 1]
    }
}

#Preview {
    PracticeView(
        engine: RhythmEngine(),
        stage: 1,
        onEnd: {}
    )
    .preferredColorScheme(.dark)
}
