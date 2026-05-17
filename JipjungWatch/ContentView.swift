import SwiftUI
import WatchKit

// 집중의 순간 - Watch 자유치기
// 목탁 이미지를 탭하면 햅틱 진동 + 카운트 증가
// 색상: MetallicBronze(#B18F7C) 테두리, 어두운 배경

struct ContentView: View {

    @State private var count: Int = 0
    @State private var isPressed: Bool = false

    // MetallicBronze
    let bronze = Color(red: 0.694, green: 0.561, blue: 0.486)
    // 아이보리
    let ivory = Color(red: 0.918, green: 0.902, blue: 0.882)

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.06, blue: 0.05)
                .ignoresSafeArea()

            VStack(spacing: 12) {

                // 카운트 표시
                Text("\(count)")
                    .font(.system(size: 36, weight: .thin))
                    .foregroundColor(ivory)
                    .monospacedDigit()

                // 목탁 버튼
                Button(action: tap) {
                    ZStack {
                        // 배경 원
                        Circle()
                            .fill(Color(red: 0.12, green: 0.10, blue: 0.09))
                            .frame(width: 90, height: 90)
                            .overlay(
                                Circle()
                                    .stroke(
                                        bronze.opacity(isPressed ? 0.9 : 0.45),
                                        lineWidth: isPressed ? 1.5 : 0.8
                                    )
                            )
                            .scaleEffect(isPressed ? 0.93 : 1.0)

                        // 목탁 이미지 — Bundle에서 직접 로드
                        if let img = loadMoktakImage() {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 54, height: 54)
                                .scaleEffect(isPressed ? 0.90 : 1.0)
                        } else {
                            // 이미지 없을 때 폴백: 목탁 모양 원
                            Circle()
                                .fill(bronze.opacity(0.6))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .fill(Color(red: 0.12, green: 0.10, blue: 0.09))
                                        .frame(width: 14, height: 14)
                                        .offset(y: 10)
                                )
                                .scaleEffect(isPressed ? 0.90 : 1.0)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeOut(duration: 0.08), value: isPressed)

                // 초기화 버튼
                Button(action: reset) {
                    Text("초기화")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(bronze.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - 이미지 로드 (Watch Bundle에서)
    private func loadMoktakImage() -> UIImage? {
        // 1순위: Assets catalog
        if let img = UIImage(named: "moktak") { return img }
        // 2순위: Bundle 직접 탐색
        let names = ["moktak", "moktak_master", "moktak_free"]
        for name in names {
            for ext in ["png", "jpg", "jpeg"] {
                if let path = Bundle.main.path(forResource: name, ofType: ext),
                   let img = UIImage(contentsOfFile: path) {
                    return img
                }
            }
        }
        return nil
    }

    // MARK: - Actions
    private func tap() {
        WKInterfaceDevice.current().play(.click)
        count += 1
        withAnimation(.easeOut(duration: 0.08)) { isPressed = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.easeOut(duration: 0.15)) { isPressed = false }
        }
    }

    private func reset() {
        WKInterfaceDevice.current().play(.success)
        withAnimation { count = 0 }
    }
}

#Preview {
    ContentView()
}
