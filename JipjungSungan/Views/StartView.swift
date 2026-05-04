import SwiftUI

// 집중의 순간 - 시작 화면
// 디자인: 소소하고 화려하지 않은 느낌, 목탁 테마
// 1~4단계 버튼 + 5단계(심장) + 달의 기운 버튼

struct StartView: View {
    let onSelectStage: (Int) -> Void
    let onCalendar: () -> Void

    @State private var appear = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 상단 여백
                Spacer().frame(height: 60)

                // 앱 타이틀
                titleSection

                Spacer().frame(height: 48)

                // 목탁 아이콘 (텍스트 기반)
                moktakIcon

                Spacer().frame(height: 48)

                // 단계 선택 버튼들
                stageButtons

                Spacer().frame(height: 24)

                // 5단계 심장 버튼
                heartStageButton

                Spacer().frame(height: 32)

                // 달의 기운 버튼
                calendarButton

                Spacer().frame(height: 48)
            }
            .padding(.horizontal, 28)
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.6)) {
                appear = true
            }
        }
    }

    // MARK: - Title Section
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text(t.appTitle)
                .font(.system(size: 28, weight: .thin, design: .default))
                .foregroundColor(AppColors.gold)
                .tracking(6)

            Text(t.appSubtitle)
                .font(.system(size: 13, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(2)
        }
    }

    // MARK: - Moktak Icon (텍스트 기반 심볼)
    private var moktakIcon: some View {
        ZStack {
            // 외부 원
            Circle()
                .stroke(AppColors.goldAlpha15, lineWidth: 1)
                .frame(width: 140, height: 140)

            // 내부 원
            Circle()
                .stroke(AppColors.goldAlpha30, lineWidth: 1)
                .frame(width: 100, height: 100)

            // 목탁 이미지
            if UIImage(named: "moktak") != nil {
                Image("moktak")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Text("木鐸")
                    .font(.system(size: 28, weight: .thin))
                    .foregroundColor(AppColors.goldDim)
            }
        }
    }

    // MARK: - Stage Buttons (1~4단계)
    private var stageButtons: some View {
        VStack(spacing: 12) {
            Text(t.startDesc1)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(1)
                .padding(.bottom, 4)

            ForEach(1...4, id: \.self) { stage in
                StageButton(
                    stage: stage,
                    onTap: { onSelectStage(stage) }
                )
            }
        }
    }

    // MARK: - Heart Stage Button (5단계)
    private var heartStageButton: some View {
        Button(action: { onSelectStage(5) }) {
            HStack(spacing: 12) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.gold)

                VStack(alignment: .leading, spacing: 2) {
                    Text(t.stageLabels[4])
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.gold)

                    Text(t.stageDescriptions[4])
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(AppColors.white30)
                }

                Spacer()

                Text("♡")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.goldDim)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
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

    // MARK: - Calendar Button
    private var calendarButton: some View {
        Button(action: onCalendar) {
            Text(t.calendarButton)
                .font(.system(size: 13, weight: .light))
                .foregroundColor(AppColors.white50)
                .tracking(1)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.white10, lineWidth: 1)
                )
        }
    }
}

// MARK: - Stage Button Component
struct StageButton: View {
    let stage: Int
    let onTap: () -> Void

    private var config: StageConfig { stageConfigs[stage - 1] }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // 단계 번호
                ZStack {
                    Circle()
                        .fill(AppColors.goldAlpha15)
                        .frame(width: 32, height: 32)
                    Text("\(stage)")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.gold)
                }

                // 단계 정보
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(t.stageLabels[stage - 1])
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppColors.white80)

                        Text("\(Int(config.bpm)) BPM")
                            .font(.system(size: 11, weight: .light))
                            .foregroundColor(AppColors.goldDim)
                    }

                    Text(t.stageDescriptions[stage - 1])
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(AppColors.white30)
                }

                Spacer()

                // 가이드 빛 표시
                if config.hasGuideLight {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 6))
                        .foregroundColor(AppColors.goldDim)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.surface)
            )
        }
    }
}

#Preview {
    StartView(
        onSelectStage: { _ in },
        onCalendar: {}
    )
    .preferredColorScheme(.dark)
}
