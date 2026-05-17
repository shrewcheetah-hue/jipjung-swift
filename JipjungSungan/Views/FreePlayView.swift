import SwiftUI
import SpriteKit
import AVFoundation

// 자유치기 수행 화면
// 타이밍 링 없이 자유롭게 탭 → SpriteKit 파티클 효과
struct FreePlayView: View {
    let mode: FreePlayMode
    let onEnd: () -> Void

    @State private var count: Int = 0
    @State private var tapScale: CGFloat = 1.0
    @State private var tapGlow: CGFloat = 0.0
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showEndConfirm = false

    // SpriteKit 씬
    @State private var meritScene = MeritParticleScene()
    @State private var karmaScene = KarmaParticleScene()

    // 모드별 색상
    private var accentColor: Color {
        mode == .merit
            ? AppColors.gold
            : Color(red: 0.90, green: 0.45, blue: 0.20)
    }
    private var glowColor: Color {
        mode == .merit
            ? Color(red: 0.95, green: 0.82, blue: 0.40)
            : Color(red: 0.95, green: 0.35, blue: 0.15)
    }
    private var bgColor: Color {
        mode == .merit
            ? AppColors.backgroundDeep
            : Color(red: 0.06, green: 0.04, blue: 0.03)
    }
    private var modeTitle: String {
        mode == .merit ? "공덕" : "업장소멸"
    }
    private var countLabel: String {
        mode == .merit ? "공덕 \(count)회" : "업장 \(count)개 소멸"
    }
    private var soundName: String {
        // 공덕: moktak1, 업장소멸: moktak3 (짧고 강한 소리)
        mode == .merit ? "moktak1" : "moktak3"
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor.ignoresSafeArea()

                // SpriteKit 파티클 레이어 (배경)
                SpriteView(scene: mode == .merit ? meritScene : karmaScene,
                           options: [.allowsTransparency])
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    // 상단 바
                    topBar

                    Spacer()

                    // 목탁 탭 영역
                    moktakArea(geo: geo)

                    Spacer()

                    // 카운트 표시
                    countDisplay

                    Spacer(minLength: 40)

                    // 종료 버튼
                    endButton
                        .padding(.bottom, 40)
                }
            }
            .onAppear {
                setupAudio()
                startTimer()
                // 씬 크기 설정
                meritScene.size = geo.size
                karmaScene.size = geo.size
            }
            .onDisappear {
                timer?.invalidate()
            }
            .alert("수행을 마치겠습니까?", isPresented: $showEndConfirm) {
                Button("계속하기", role: .cancel) {}
                Button("마치기", role: .destructive) { onEnd() }
            }
        }
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(modeTitle)
                    .font(.system(size: 18, weight: .medium))
                    .tracking(4)
                    .foregroundColor(accentColor)
                Text(timeString(elapsedSeconds))
                    .font(.system(size: 13, weight: .light).monospacedDigit())
                    .foregroundColor(accentColor.opacity(0.6))
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    // MARK: - Moktak Area
    private func moktakArea(geo: GeometryProxy) -> some View {
        let size = min(geo.size.width * 0.68, 280.0)
        return ZStack {
            // 배경 glow
            Circle()
                .fill(glowColor.opacity(0.08 + tapGlow * 0.18))
                .frame(width: size * 1.4, height: size * 1.4)
                .blur(radius: 30)

            // 목탁 이미지
            Image("moktak")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(tapScale)
                .shadow(color: glowColor.opacity(0.3 + tapGlow * 0.5), radius: 20 + tapGlow * 30)
        }
        .frame(width: size * 1.5, height: size * 1.5)
        .contentShape(Rectangle())
        .onTapGesture {
            handleTap(in: geo)
        }
    }

    // MARK: - Count Display
    private var countDisplay: some View {
        VStack(spacing: 6) {
            Text("\(count)")
                .font(.system(size: 72, weight: .thin).monospacedDigit())
                .foregroundColor(accentColor)
                .shadow(color: glowColor.opacity(0.4), radius: 12)
            Text(mode == .merit ? "공덕" : "업장소멸")
                .font(.system(size: 14, weight: .light))
                .tracking(4)
                .foregroundColor(accentColor.opacity(0.6))
        }
    }

    // MARK: - End Button
    private var endButton: some View {
        Button(action: { showEndConfirm = true }) {
            Text("수행 마치기")
                .font(.system(size: 16, weight: .light))
                .tracking(3)
                .foregroundColor(accentColor.opacity(0.7))
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Tap Handler
    private func handleTap(in geo: GeometryProxy) {
        count += 1
        playSound()

        // 목탁 눌림 효과
        withAnimation(.easeOut(duration: 0.07)) {
            tapScale = 0.92
            tapGlow = 1.0
        }
        withAnimation(.easeIn(duration: 0.18).delay(0.07)) {
            tapScale = 1.0
            tapGlow = 0.0
        }

        // SpriteKit 파티클 방출 (목탁 중앙 위치)
        let centerX = geo.size.width / 2
        let centerY = geo.size.height / 2
        let skPoint = CGPoint(x: centerX, y: centerY)

        if mode == .merit {
            meritScene.burst(at: skPoint)
        } else {
            karmaScene.burst(at: skPoint)
        }

        // 햅틱
        let impact = UIImpactFeedbackGenerator(style: mode == .merit ? .light : .medium)
        impact.impactOccurred()
    }

    // MARK: - Audio
    private func setupAudio() {
        if let url = Bundle.main.url(forResource: soundName, withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        }
    }

    private func playSound() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    // MARK: - Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedSeconds += 1
        }
    }

    private func timeString(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    FreePlayView(mode: .merit, onEnd: {})
}
