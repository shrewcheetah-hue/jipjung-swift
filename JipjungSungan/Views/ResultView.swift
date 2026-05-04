import SwiftUI

// 집중의 순간 - 수행 결과 화면
// 통계 카드, 격려 메시지, 다시하기 버튼

struct ResultView: View {
    let result: PracticeResult
    let onRestart: () -> Void

    @State private var appear = false

    private var encourageMessage: String {
        let msgs = t.resultMessages
        if result.bestConsecutive >= 10 {
            return msgs[0]
        } else if result.bestConsecutive >= 5 {
            return msgs[1]
        } else if result.totalHits >= 10 {
            return msgs[2]
        } else {
            return msgs[3]
        }
    }

    private var elapsedFormatted: String {
        let m = result.elapsedSeconds / 60
        let s = result.elapsedSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                // 완료 심볼
                completionSymbol

                Spacer().frame(height: 32)

                // 타이틀
                VStack(spacing: 8) {
                    Text(t.resultTitle)
                        .font(.system(size: 24, weight: .thin))
                        .foregroundColor(AppColors.gold)
                        .tracking(4)

                    Text(t.resultSubtitle)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(AppColors.white30)
                        .multilineTextAlignment(.center)
                        .tracking(1)
                }

                Spacer().frame(height: 40)

                // 통계 카드
                statsGrid

                Spacer().frame(height: 32)

                // 구분선
                Rectangle()
                    .fill(AppColors.white10)
                    .frame(height: 1)
                    .padding(.horizontal, 40)

                Spacer().frame(height: 24)

                // 격려 메시지
                Text(encourageMessage)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .tracking(0.5)

                Spacer().frame(height: 40)

                // 다시하기 버튼
                restartButton

                Spacer()
            }
            .padding(.horizontal, 28)
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) {
                appear = true
            }
        }
    }

    // MARK: - Completion Symbol
    private var completionSymbol: some View {
        ZStack {
            // 황금빛 glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.55, green: 0.35, blue: 0.15).opacity(0.4),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 70
                    )
                )
                .frame(width: 140, height: 140)

            // 목탁 이미지
            if UIImage(named: "moktak") != nil {
                Image("moktak")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
            } else {
                Text("木鐸")
                    .font(.system(size: 36, weight: .thin))
                    .foregroundColor(AppColors.goldDim)
            }
        }
    }

    // MARK: - Stats Grid
    private var statsGrid: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatCard(
                    label: t.statTotalHits,
                    value: "\(result.totalHits)",
                    unit: "회"
                )
                StatCard(
                    label: t.statBestConsecutive,
                    value: "\(result.bestConsecutive)",
                    unit: "연속"
                )
            }
            HStack(spacing: 16) {
                StatCard(
                    label: t.statStageReached,
                    value: "\(result.stageReached)",
                    unit: "단계"
                )
                StatCard(
                    label: t.statPracticeTime,
                    value: elapsedFormatted,
                    unit: ""
                )
            }
        }
    }

    // MARK: - Restart Button
    private var restartButton: some View {
        Button(action: onRestart) {
            Text(t.restartButton)
                .font(.system(size: 15, weight: .light))
                .foregroundColor(AppColors.gold)
                .tracking(2)
                .padding(.vertical, 14)
                .padding(.horizontal, 40)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(AppColors.goldAlpha08)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(AppColors.goldAlpha30, lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Stat Card Component
struct StatCard: View {
    let label: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(0.5)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .thin, design: .monospaced))
                    .foregroundColor(AppColors.white80)

                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(AppColors.white30)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.surface)
        )
    }
}

#Preview {
    ResultView(
        result: PracticeResult(
            totalHits: 42,
            bestConsecutive: 7,
            stageReached: 2,
            elapsedSeconds: 185
        ),
        onRestart: {}
    )
    .preferredColorScheme(.dark)
}
