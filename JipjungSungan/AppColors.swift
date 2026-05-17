import SwiftUI

// 집중의 순간 - 디자인 철학: 소소하고 화려하지 않은 느낌, 핸드폰이 목탁처럼 보이도록
struct AppColors {
    // 배경 - 깊은 어둠 (목탁의 나무 색감에서 영감)
    static let background = Color(red: 0.08, green: 0.07, blue: 0.06)
    static let backgroundDeep = Color(red: 0.05, green: 0.04, blue: 0.03)
    static let surface = Color(red: 0.12, green: 0.11, blue: 0.09)

    // 금색 계열 - 절의 촛불, 금박
    static let gold = Color(red: 0.85, green: 0.72, blue: 0.42)
    static let goldBright = Color(red: 0.95, green: 0.85, blue: 0.55)
    static let goldDim = Color(red: 0.65, green: 0.54, blue: 0.30)
    static let goldAlpha15 = Color(red: 0.85, green: 0.72, blue: 0.42).opacity(0.15)
    static let goldAlpha08 = Color(red: 0.85, green: 0.72, blue: 0.42).opacity(0.08)
    static let goldAlpha30 = Color(red: 0.85, green: 0.72, blue: 0.42).opacity(0.30)

    // 흰색 계열
    static let white80 = Color.white.opacity(0.80)
    static let white50 = Color.white.opacity(0.50)
    static let white40 = Color.white.opacity(0.40)
    static let white30 = Color.white.opacity(0.30)
    static let white10 = Color.white.opacity(0.10)

    // 히트 결과 색상
    static let perfect = Color(red: 0.85, green: 0.72, blue: 0.42)  // 금색
    static let near = Color(red: 0.70, green: 0.85, blue: 0.65)      // 연두
    static let off = Color(red: 1.0, green: 0.294, blue: 0.447)      // neonGlowPink (OFF 판정)

    // 빨간색 (일요일) → neonGlowPink 계열
    static let red = Color(red: 1.0, green: 0.294, blue: 0.447)

    // --- 새 팔레트 ---
    // 로즈 골드 + 브론즈 #B18F7C - 원 게이지 포인트
    static let metallicBronze = Color(red: 0.694, green: 0.561, blue: 0.486)
    static let metallicBronzeAlpha30 = Color(red: 0.694, green: 0.561, blue: 0.486).opacity(0.30)
    static let metallicBronzeAlpha15 = Color(red: 0.694, green: 0.561, blue: 0.486).opacity(0.15)

    // 밝은 실버 화이트 #E5E9F0 - 심장 원 후광
    static let silverWhite = Color(red: 0.898, green: 0.914, blue: 0.941)
    static let silverWhiteAlpha30 = Color(red: 0.898, green: 0.914, blue: 0.941).opacity(0.30)
    static let silverWhiteAlpha15 = Color(red: 0.898, green: 0.914, blue: 0.941).opacity(0.15)

    // 네온 핑크/레드 #FF4B72 - OFF 판정, 업장소멸 강조, 일요일 표시
    static let neonGlowPink = Color(red: 1.0, green: 0.294, blue: 0.447)
    static let neonGlowPinkAlpha40 = Color(red: 1.0, green: 0.294, blue: 0.447).opacity(0.40)
    static let neonGlowPinkAlpha20 = Color(red: 1.0, green: 0.294, blue: 0.447).opacity(0.20)
    static let neonGlowPinkAlpha12 = Color(red: 1.0, green: 0.294, blue: 0.447).opacity(0.12)
    static let neonGlowPinkAlpha08 = Color(red: 1.0, green: 0.294, blue: 0.447).opacity(0.08)

    // 톤다운된 쿠퍼 / 어두운 웜 그레이 #4E433B - 하단 박스 테두리
    static let darkCopper = Color(red: 0.306, green: 0.263, blue: 0.231)
    static let darkCopperAlpha60 = Color(red: 0.306, green: 0.263, blue: 0.231).opacity(0.60)
}
