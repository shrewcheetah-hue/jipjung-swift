import SwiftUI

// 집중의 순간 - 시작 화면
// 디자인: 목탁 크게 (화면 상단 절반), 설명 텍스트 2줄, 하단 원형 BPM 버튼 5개

struct StartView: View {
    let onSelectStage: (Int) -> Void
    let onCalendar: () -> Void
    let onFreePlay: () -> Void

    @State private var appear = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 배경
                Color(red: 0.08, green: 0.07, blue: 0.06).ignoresSafeArea()

                VStack(spacing: 0) {
                    // 상단 여백
                    Spacer().frame(height: 20)

                    // 목탁 영역 (화면 상단 절반)
                    moktakSection(width: geo.size.width)

                    Spacer().frame(height: 20)

                    // 설명 텍스트
                    descriptionText

                    Spacer().frame(height: 24)

                    // 하단 단계 선택 버튼 (원형 BPM)
                    stageCircleButtons

                    Spacer().frame(height: 20)

                    // 하단 버튼 행 (달의 기운 + 자유치기)
                    bottomButtons

                    Spacer().frame(height: 24)
                }
            }
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.8)) {
                appear = true
            }
        }
    }

    // MARK: - Moktak Section
    private func moktakSection(width: CGFloat) -> some View {
        let imgSize = width * 0.50

        return ZStack {
            // 뒤쪽 부드러운 원형 glow
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.55, green: 0.35, blue: 0.15).opacity(0.35),
                            Color.clear
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: imgSize * 0.55
                    )
                )
                .frame(width: imgSize * 1.1, height: imgSize * 1.1)

            // 목탁 이미지
            if UIImage(named: "moktak") != nil {
                Image("moktak")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgSize, height: imgSize)
            } else {
                Text("木鐸")
                    .font(.system(size: 60, weight: .thin))
                    .foregroundColor(AppColors.goldDim)
            }
        }
        .frame(height: imgSize)
    }

    // MARK: - Description Text
    private var descriptionText: some View {
        VStack(spacing: 8) {
            Text("목탁 소리에 집중하며")
                .font(.system(size: 17, weight: .light))
                .foregroundColor(AppColors.white80)
                .tracking(3)

            Text("내면의 고요함을 찾아가는 수행")
                .font(.system(size: 17, weight: .light))
                .foregroundColor(AppColors.white80)
                .tracking(3)
        }
    }

    // MARK: - Stage Circle Buttons
    private var stageCircleButtons: some View {
        HStack(spacing: 0) {
            ForEach(1...5, id: \.self) { stage in
                Spacer()
                StageCircleButton(stage: stage, onTap: { onSelectStage(stage) })
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Bottom Buttons
    private var bottomButtons: some View {
        VStack(spacing: 12) {
            Button(action: onFreePlay) {
                HStack(spacing: 6) {
                    Image("moktak")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .opacity(0.7)
                    Text("자유치기")
                        .font(.system(size: 12, weight: .light))
                        .tracking(1)
                }
                .foregroundColor(AppColors.goldDim)
                .padding(.vertical, 10)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.goldAlpha15, lineWidth: 1)
                )
            }
            Button(action: onCalendar) {
                Text(t.calendarButton)
                    .font(.system(size: 12, weight: .light))
                    .foregroundColor(AppColors.white30)
                    .tracking(1)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(AppColors.white10, lineWidth: 1)
                    )
            }
        }
    }
}

// MARK: - Stage Circle Button Component
struct StageCircleButton: View {
    let stage: Int
    let onTap: () -> Void

    private var config: StageConfig { stageConfigs[stage - 1] }
    private var isHeart: Bool { stage == 5 }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // 원형 버튼
                ZStack {
                    Circle()
                        .fill(AppColors.surface)
                        .overlay(
                            Circle()
                                .stroke(
                                    isHeart ? AppColors.goldAlpha30 : AppColors.goldAlpha15,
                                    lineWidth: isHeart ? 1.5 : 1
                                )
                        )
                        .frame(width: 58, height: 58)

                    if isHeart {
                        Text("❤️")
                            .font(.system(size: 22))
                    } else {
                        Text("\(Int(config.bpm))")
                            .font(.system(size: 16, weight: .light, design: .monospaced))
                            .foregroundColor(AppColors.white80)
                    }
                }

                // 단계 이름
                Text(t.stageLabels[stage - 1])
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .tracking(0.5)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    StartView(
        onSelectStage: { _ in },
        onCalendar: {},
        onFreePlay: {}
    )
    .preferredColorScheme(.dark)
}
