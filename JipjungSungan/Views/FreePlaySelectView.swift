import SwiftUI

// 자유치기 모드 선택 화면
// 공덕(功德) - 금빛 파티클 / 업장소멸(業障消滅) - 붉은 불꽃 파티클
enum FreePlayMode {
    case merit    // 공덕
    case karma    // 업장소멸
}

struct FreePlaySelectView: View {
    let onSelect: (FreePlayMode) -> Void
    let onBack: () -> Void

    @State private var meritGlow = false
    @State private var karmaGlow = false

    var body: some View {
        ZStack {
            AppColors.backgroundDeep.ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 뒤로가기
                HStack {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(AppColors.gold)
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
                        .foregroundColor(AppColors.gold)
                    Text("원하는 수행을 선택하세요")
                        .font(.system(size: 14, weight: .light))
                        .tracking(2)
                        .foregroundColor(AppColors.white30)
                }

                Spacer()

                // 두 모드 카드
                VStack(spacing: 24) {
                    // 공덕 카드
                    ModeCard(
                        title: "공덕",
                        subtitle: "功德",
                        description: "목탁 소리로 공덕을 쌓습니다\n빛이 모여 마음을 밝힙니다",
                        accentColor: AppColors.gold,
                        glowColor: Color(red: 0.95, green: 0.82, blue: 0.40),
                        icon: "sparkles",
                        isGlowing: meritGlow
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) { meritGlow = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            onSelect(.merit)
                        }
                    }
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                            meritGlow = true
                        }
                    }

                    // 업장소멸 카드
                    ModeCard(
                        title: "업장소멸",
                        subtitle: "業障消滅",
                        description: "목탁 소리로 업장을 소멸합니다\n불꽃이 번뇌를 태워냅니다",
                        accentColor: Color(red: 0.90, green: 0.45, blue: 0.20),
                        glowColor: Color(red: 0.95, green: 0.35, blue: 0.15),
                        icon: "flame",
                        isGlowing: karmaGlow
                    ) {
                        withAnimation(.easeInOut(duration: 0.15)) { karmaGlow = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            onSelect(.karma)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                                karmaGlow = true
                            }
                        }
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
    let accentColor: Color
    let glowColor: Color
    let icon: String
    let isGlowing: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.12))
                        .frame(width: 64, height: 64)
                        .blur(radius: isGlowing ? 8 : 4)
                    Circle()
                        .stroke(accentColor.opacity(0.4), lineWidth: 1)
                        .frame(width: 64, height: 64)
                    Image(systemName: icon)
                        .font(.system(size: 26))
                        .foregroundColor(accentColor)
                }

                // 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(title)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(accentColor)
                        Text(subtitle)
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(accentColor.opacity(0.6))
                    }
                    Text(description)
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(AppColors.white50)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(accentColor.opacity(0.5))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(accentColor.opacity(isGlowing ? 0.35 : 0.15), lineWidth: 1)
                    )
            )
            .shadow(color: glowColor.opacity(isGlowing ? 0.25 : 0.05), radius: isGlowing ? 16 : 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    FreePlaySelectView(onSelect: { _ in }, onBack: {})
}
