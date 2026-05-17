import SwiftUI
import WatchKit

// 집중의 순간 - Watch 자유치기
// 목탁 이미지를 탭하면 햅틱 진동 + 카운트 증가
// 색상: MetallicBronze(#B18F7C) 테두리, 어두운 배경

struct ContentView: View {

    @State private var count: Int = 0
    @State private var isPressed: Bool = false
    @State private var showReset: Bool = false

    var body: some View {
        ZStack {
            // 배경
            Color(red: 0.07, green: 0.06, blue: 0.05)
                .ignoresSafeArea()

            VStack(spacing: 12) {

                // 카운트 표시
                Text("\(count)")
                    .font(.system(size: 36, weight: .thin, design: .default))
                    .foregroundColor(Color(red: 0.918, green: 0.902, blue: 0.882))
                    .monospacedDigit()
                    .animation(.easeInOut(duration: 0.1), value: count)

                // 목탁 버튼
                Button(action: tap) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.12, green: 0.10, blue: 0.09))
                            .frame(width: 90, height: 90)
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color(red: 0.694, green: 0.561, blue: 0.486)
                                            .opacity(isPressed ? 0.9 : 0.45),
                                        lineWidth: isPressed ? 1.5 : 0.8
                                    )
                            )
                            .scaleEffect(isPressed ? 0.93 : 1.0)
                            .shadow(
                                color: Color(red: 0.694, green: 0.561, blue: 0.486)
                                    .opacity(isPressed ? 0.35 : 0.0),
                                radius: isPressed ? 12 : 0
                            )

                        Image("moktak")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 54)
                            .scaleEffect(isPressed ? 0.90 : 1.0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeOut(duration: 0.08), value: isPressed)

                // 리셋 버튼
                Button(action: reset) {
                    Text("초기화")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(Color(red: 0.694, green: 0.561, blue: 0.486).opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Actions

    private func tap() {
        // 햅틱 진동
        WKInterfaceDevice.current().play(.click)

        // 카운트 증가
        count += 1

        // 눌림 애니메이션
        withAnimation(.easeOut(duration: 0.08)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.easeOut(duration: 0.15)) {
                isPressed = false
            }
        }
    }

    private func reset() {
        WKInterfaceDevice.current().play(.success)
        withAnimation(.easeInOut(duration: 0.2)) {
            count = 0
        }
    }
}

#Preview {
    ContentView()
}
