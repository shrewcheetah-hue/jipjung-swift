import SwiftUI

// 자유치기 모드 선택 화면
// 색상 철학: 두 카드 모두 중립 아이보리/다크브라운으로 통일 — 소소하고 차분한 목탁 앱 감성

enum FreePlayMode {
    case merit    // 공덕
    case karma    // 업장소멸
}

// 중립 색상 상수
private let cardText     = Color(red: 0.918, green: 0.902, blue: 0.882)  // #EAE6E1 아이보리
private let cardBorder   = Color(red: 0.227, green: 0.204, blue: 0.188)  // #3A3430 다크브라운
private let cardIconBg   = Color(red: 0.227, green: 0.204, blue: 0.188).opacity(0.5)

struct FreePlaySelectView: View {
    let onSelect: (FreePlayMode) -> Void
    let onBack: () -> Void

    var body: some View {
        ZStack {
            AppColors.backgroundDeep.ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 뒤로가기
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.white50)
                            .padding(12)
                    }
                    Spacer()
                }
                .padding(.top, 8)

                Spacer()

                // 타이틀
                VStack(spacing: 8) {
                    Text("자유 수행")
                        .font(.system(size: 28, weight: .thin))
                        .tracking(8)
                        .foregroundColor(AppColors.white80)
                    Text("원하는 수행을 선택하세요")
                        .font(.system(size: 14, weight: .light))
                        .tracking(2)
                        .foregroundColor(AppColors.white30)
                }

                Spacer()

                // 두 모드 카드
                VStack(spacing: 24) {
                    ModeCard(
                        title: "공덕",
                        subtitle: "功德",
                        description: "목탁 소리로 공덕을 쌓습니다\n빛이 모여 마음을 밝힙니다",
                        customImage: "lotus"
                    ) {
                        onSelect(.merit)
                    }

                    ModeCard(
                        title: "업장소멸",
                        subtitle: "業障消滅",
                        description: "목탁 소리로 업장을 소멸합니다\n불꽃이 번뇌를 태워냅니다",
                        customImage: "karma_flame"
                    ) {
                        onSelect(.karma)
                    }
                }
                .padding(.horizontal, 28)

                Spacer()
                Spacer()
            }
        }
    }
}

// MARK: - Mode Card
struct ModeCard: View {
    let title: String
    let subtitle: String
    let description: String
    var customImage: String? = nil
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                // 아이콘 원
                ZStack {
                    Circle()
                        .fill(cardIconBg)
                        .frame(width: 64, height: 64)
                    Circle()
                        .stroke(cardBorder, lineWidth: 0.8)
                        .frame(width: 64, height: 64)
                    if let imgName = customImage {
                        Image(imgName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                    }
                }

                // 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(title)
                            .font(.system(size: 22, weight: .light))
                            .foregroundColor(cardText)
                        Text(subtitle)
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(cardText.opacity(0.45))
                    }
                    Text(description)
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(AppColors.white40)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 13))
                    .foregroundColor(cardText.opacity(0.30))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(cardBorder, lineWidth: 0.8)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FreePlaySelectView(onSelect: { _ in }, onBack: {})
}
