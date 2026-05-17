import SwiftUI
import WatchKit

// 집중의 순간 Watch - 자유치기
// MetallicBronze(#B18F7C) 원 테두리, 어두운 배경

struct ContentView: View {

    @State private var count: Int = 0
    @State private var isPressed: Bool = false

    let bronze = Color(red: 0.694, green: 0.561, blue: 0.486)
    let ivory  = Color(red: 0.918, green: 0.902, blue: 0.882)

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.06, blue: 0.05)
                .ignoresSafeArea()

            VStack(spacing: 12) {

                // 타수 카운트
                Text("\(count)")
                    .font(.system(size: 36, weight: .thin))
                    .foregroundColor(ivory)
                    .monospacedDigit()

                // 목탁 버튼
                Button(action: tap) {
                    ZStack {
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

                        Image("moktak")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 54)
                            .scaleEffect(isPressed ? 0.90 : 1.0)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .animation(.easeOut(duration: 0.08), value: isPressed)

                // 초기화
                Button(action: reset) {
                    Text("초기화")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(bronze.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

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
