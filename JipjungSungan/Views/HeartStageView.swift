import SwiftUI

// 집중의 순간 - 5단계 소원빌기 화면
// 무념무상 or 소원빌기 선택 → 심박수 측정 → 수행 시작

enum HeartPracticeMode {
    case empty   // 무념무상
    case wish    // 소원빌기
}

struct HeartStageView: View {
    let onStart: (Double) -> Void
    let onBack: () -> Void

    @State private var selectedMode: HeartPracticeMode? = nil
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

                Spacer().frame(height: 32)

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

                Spacer().frame(height: 24)

                // 목탁 이미지
                Image("moktak")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .opacity(0.85)

                Spacer().frame(height: 28)

                // 모드 선택 (무념무상 / 소원빌기)
                modeSelector

                Spacer().frame(height: 24)

                // 심박 표시 원
                heartDisplay

                Spacer().frame(height: 24)

                // 설명 텍스트
                Text(modeDescription)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 32)
                    .animation(.easeInOut(duration: 0.3), value: selectedMode)

                Spacer().frame(height: 32)

                // 탭 버튼
                tapButton

                Spacer().frame(height: 16)

                // 리셋 버튼
                if !tapTimes.isEmpty {
                    resetButton
                }

                Spacer().frame(height: 20)

                // 수행 시작 버튼
                startButton

                Spacer()

                // 안내 메시지
                Text(t.heartNote)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white30)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 36)
            }
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.4)) {
                appear = true
            }
        }
    }

    // MARK: - Mode Selector
    private var modeSelector: some View {
        HStack(spacing: 0) {
            modeButton(title: "무념무상", mode: .empty)

            // 구분선
            Rectangle()
                .fill(AppColors.white10)
                .frame(width: 1, height: 36)

            modeButton(title: "소원빌기", mode: .wish)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppColors.metallicBronzeAlpha15, lineWidth: 1)
        )
        .padding(.horizontal, 48)
    }

    private func modeButton(title: String, mode: HeartPracticeMode) -> some View {
        let isSelected = selectedMode == mode
        return Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedMode = mode
            }
        }) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .regular : .light))
                .foregroundColor(isSelected ? AppColors.metallicBronze : AppColors.white30)
                .tracking(1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    isSelected
                        ? AppColors.metallicBronzeAlpha15
                        : Color.clear
                )
        }
    }

    // MARK: - Mode Description
    private var modeDescription: String {
        switch selectedMode {
        case .empty:
            return "생각을 비우세요.\n소리만 남기고, 나머지는 흐르도록 두세요."
        case .wish:
            return "마음속에 소원을 조용히 품으세요.\n목탁 소리가 그 말을 우주로 전합니다."
        case nil:
            return "심장 박동에 맞춰 화면을 탭하세요.\n측정된 BPM으로 목탁이 울립니다."
        }
    }

    // MARK: - Heart Display
    private var heartDisplay: some View {
        ZStack {
            // 외부 원
            Circle()
                .stroke(AppColors.metallicBronze, lineWidth: 1)
                .frame(width: 150, height: 150)

            // 내부 원 (심박에 맞춰 펄스)
            Circle()
                .stroke(AppColors.metallicBronze, lineWidth: 1)
                .frame(width: 100, height: 100)
                .scaleEffect(heartPulse ? 1.12 : 1.0)
                .animation(.easeOut(duration: 0.15), value: heartPulse)

            // BPM 표시
            VStack(spacing: 4) {
                if let bpm = measuredBpm {
                    Text("\(Int(bpm))")
                        .font(.system(size: 38, weight: .thin, design: .monospaced))
                        .foregroundColor(AppColors.gold)

                    Text("BPM")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(AppColors.goldDim)
                        .tracking(2)
                } else {
                    Image(systemName: "heart")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.goldDim)
                        .shadow(color: AppColors.neonGlowPinkAlpha40, radius: 8, x: 0, y: 0)

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
                    .fill(AppColors.metallicBronzeAlpha15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.silverWhiteAlpha30, lineWidth: 1)
                    )

                VStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.gold)
                        .shadow(color: AppColors.neonGlowPinkAlpha40, radius: 10, x: 0, y: 0)

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
                .padding(.vertical, 20)
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
        let canStart = measuredBpm != nil
        return Button(action: {
            if let bpm = measuredBpm {
                onStart(bpm)
            }
        }) {
            Text(t.heartStartButton(bpm: measuredBpm.map { Int($0) }))
                .font(.system(size: 15, weight: .light))
                .foregroundColor(canStart ? AppColors.gold : AppColors.white30)
                .tracking(1)
                .padding(.vertical, 14)
                .padding(.horizontal, 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(canStart ? AppColors.metallicBronzeAlpha15 : AppColors.surface)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    canStart ? AppColors.metallicBronzeAlpha30 : AppColors.darkCopper,
                                    lineWidth: 1
                                )
                        )
                )
        }
        .disabled(!canStart)
        .padding(.horizontal, 40)
    }

    // MARK: - Actions
    private func onTap() {
        let now = Date()
        tapTimes.append(now)

        heartPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            heartPulse = false
        }

        tapTimes = tapTimes.filter { now.timeIntervalSince($0) < 10.0 }

        if tapTimes.count >= minTaps {
            calculateBpm()
        }

        if tapTimes.count > maxTaps {
            tapTimes.removeFirst()
        }
    }

    private func calculateBpm() {
        guard tapTimes.count >= 2 else { return }
        let intervals = zip(tapTimes, tapTimes.dropFirst()).map { $1.timeIntervalSince($0) }
        let avgInterval = intervals.reduce(0, +) / Double(intervals.count)
        let bpm = 60.0 / avgInterval
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
