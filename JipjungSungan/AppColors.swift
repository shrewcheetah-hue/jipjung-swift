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
    static let white30 = Color.white.opacity(0.30)
    static let white10 = Color.white.opacity(0.10)

    // 히트 결과 색상
    static let perfect = Color(red: 0.85, green: 0.72, blue: 0.42)  // 금색
    static let near = Color(red: 0.70, green: 0.85, blue: 0.65)      // 연두
    static let off = Color(red: 0.80, green: 0.40, blue: 0.35)       // 붉은색

    // 빨간색 (일요일)
    static let red = Color(red: 0.80, green: 0.35, blue: 0.30)
}
