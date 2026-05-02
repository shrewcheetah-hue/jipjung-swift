import SwiftUI

// 집중의 순간 - 5단계 심박수 측정 화면
// 탭으로 BPM 측정 후 수행 시작

struct HeartStageView: View {
    let onStart: (Double) -> Void
    let onBack: () -> Void

    @State private var tapTimes: [Date] = []
    @State private var measuredBpm: Double? = nil
    @State private var heartPulse = false
    @State private var appear = false

    private let minTaps = 4
    private let maxTaps = 12

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // 뒤로가기
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 14))
                            Text("뒤로")
                                .font(.system(size: 14, weight: .light))
                        }
                        .foregroundColor(AppColors.white50)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)

                Spacer().frame(height: 40)

                // 타이틀
                VStack(spacing: 8) {
                    Text(t.heartTitle)
                        .font(.system(size: 22, weight: .thin))
                        .foregroundColor(AppColors.gold)
                        .tracking(2)

                    Text(t.heartSubtitle)
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(AppColors.white30)
                        .tracking(1)
                }

                Spacer().frame(height: 48)

                // 심박 표시 원
                heartDisplay

                Spacer().frame(height: 32)

                // 설명 텍스트
                Text(t.heartDesc)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 32)

                Spacer().frame(height: 40)

                // 탭 버튼
                tapButton

                Spacer().frame(height: 20)

                // 리셋 버튼
                if !tapTimes.isEmpty {
                    resetButton
                }

                Spacer().frame(height: 24)

                // 수행 시작 버튼
                startButton

                Spacer()

                // 안내 메시지
                Text(t.heartNote)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white30)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
            }
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.4)) {
                appear = true
            }
        }
    }

    // MARK: - Heart Display
    private var heartDisplay: some View {
        ZStack {
            // 외부 원
            Circle()
                .stroke(AppColors.goldAlpha15, lineWidth: 1)
                .frame(width: 160, height: 160)

            // 내부 원 (심박에 맞춰 펄스)
            Circle()
                .stroke(AppColors.goldAlpha30, lineWidth: 1.5)
                .frame(width: 110, height: 110)
                .scaleEffect(heartPulse ? 1.1 : 1.0)
                .animation(.easeOut(duration: 0.15), value: heartPulse)

            // BPM 표시
            VStack(spacing: 4) {
                if let bpm = measuredBpm {
                    Text("\(Int(bpm))")
                        .font(.system(size: 40, weight: .thin, design: .monospaced))
                        .foregroundColor(AppColors.gold)

                    Text("BPM")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(AppColors.goldDim)
                        .tracking(2)
                } else {
                    Image(systemName: "heart")
                        .font(.system(size: 32))
                        .foregroundColor(AppColors.goldDim)

                    Text("탭으로 측정")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(AppColors.white30)
                        .tracking(1)
                }
            }
        }
    }

    // MARK: - Tap Button
    private var tapButton: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.goldAlpha08)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.goldAlpha30, lineWidth: 1)
                    )

                VStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.gold)

                    Text(t.heartTapButton)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(AppColors.white80)
                        .tracking(1)

                    if !tapTimes.isEmpty {
                        Text("\(tapTimes.count)회 탭")
                            .font(.system(size: 11, weight: .light))
                            .foregroundColor(AppColors.goldDim)
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 40)
            }
        }
        .padding(.horizontal, 40)
    }

    // MARK: - Reset Button
    private var resetButton: some View {
        Button(action: resetTaps) {
            Text("다시 측정")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(AppColors.white30)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
        }
    }

    // MARK: - Start Button
    private var startButton: some View {
        Button(action: {
            if let bpm = measuredBpm {
                onStart(bpm)
            }
        }) {
            Text(t.heartStartButton(bpm: measuredBpm.map { Int($0) }))
                .font(.system(size: 15, weight: .light))
                .foregroundColor(measuredBpm != nil ? AppColors.gold : AppColors.white30)
                .tracking(1)
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(measuredBpm != nil ? AppColors.goldAlpha15 : AppColors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    measuredBpm != nil ? AppColors.goldAlpha30 : AppColors.white10,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .disabled(measuredBpm == nil)
        .padding(.horizontal, 40)
    }

    // MARK: - Actions
    private func onTap() {
        let now = Date()
        tapTimes.append(now)

        // 심박 펄스 애니메이션
        heartPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            heartPulse = false
        }

        // 오래된 탭 제거 (최근 10초)
        tapTimes = tapTimes.filter { now.timeIntervalSince($0) < 10.0 }

        // BPM 계산 (최소 minTaps 이상)
        if tapTimes.count >= minTaps {
            calculateBpm()
        }

        // 최대 탭 수 초과 시 오래된 것 제거
        if tapTimes.count > maxTaps {
            tapTimes.removeFirst()
        }
    }

    private func calculateBpm() {
        guard tapTimes.count >= 2 else { return }
        let intervals = zip(tapTimes, tapTimes.dropFirst()).map { $1.timeIntervalSince($0) }
        let avgInterval = intervals.reduce(0, +) / Double(intervals.count)
        let bpm = 60.0 / avgInterval
        // 합리적인 범위로 제한 (40~200 BPM)
        measuredBpm = max(40, min(200, bpm))
    }

    private func resetTaps() {
        tapTimes = []
        measuredBpm = nil
    }
}

#Preview {
    HeartStageView(
        onStart: { _ in },
        onBack: {}
    )
    .preferredColorScheme(.dark)
}
