import SwiftUI
import SpriteKit
import AVFoundation

// 자유치기 수행 화면
// 공덕: 자유롭게 / 업장소멸: 108번 기본 목표, 달성 후 계속 가능
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

    // 업장소멸 108번 달성 관련
    @State private var roundsCompleted: Int = 0       // 108번 완료 횟수
    @State private var show108Celebration = false     // 108번 달성 축하 표시
    @State private var celebrationScale: CGFloat = 0.5

    // SpriteKit 씬
    @State private var meritScene = MeritParticleScene()
    @State private var karmaScene = KarmaParticleScene()

    private let karmaGoal = 108

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
    private var soundName: String {
        mode == .merit ? "moktak1" : "moktak3"
    }

    // 업장소멸 현재 라운드 내 진행 횟수
    private var currentRoundCount: Int {
        mode == .karma ? count % karmaGoal : count
    }
    // 업장소멸 진행률 (0~1)
    private var karmaProgress: CGFloat {
        mode == .karma ? CGFloat(currentRoundCount) / CGFloat(karmaGoal) : 0
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

                // 108번 달성 축하 오버레이
                if show108Celebration {
                    celebrationOverlay
                }
            }
            .onAppear {
                setupAudio()
                startTimer()
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
            // 업장소멸: 완료 라운드 표시
            if mode == .karma && roundsCompleted > 0 {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(roundsCompleted)순")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(accentColor)
                    Text("108번 완료")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(accentColor.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    // MARK: - Moktak Area
    private func moktakArea(geo: GeometryProxy) -> some View {
        let size = min(geo.size.width * 0.68, 280.0)
        return ZStack {
            // 업장소멸: 진행률 링
            if mode == .karma {
                // 배경 링
                Circle()
                    .stroke(accentColor.opacity(0.12), lineWidth: 3)
                    .frame(width: size * 1.15, height: size * 1.15)

                // 진행률 링
                Circle()
                    .trim(from: 0, to: karmaProgress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [accentColor.opacity(0.3), accentColor]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: size * 1.15, height: size * 1.15)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.1), value: karmaProgress)

                // 남은 횟수 표시 (108번 미달성 시)
                if currentRoundCount < karmaGoal {
                    VStack(spacing: 2) {
                        Text("\(karmaGoal - currentRoundCount)")
                            .font(.system(size: 13, weight: .light).monospacedDigit())
                            .foregroundColor(accentColor.opacity(0.7))
                        Text("번 남음")
                            .font(.system(size: 10, weight: .light))
                            .foregroundColor(accentColor.opacity(0.4))
                    }
                    .offset(y: size * 0.72)
                }
            }

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
            if mode == .karma {
                // 업장소멸: 현재 라운드 내 횟수 크게, 전체 누적 작게
                Text("\(currentRoundCount == 0 && count > 0 ? karmaGoal : currentRoundCount)")
                    .font(.system(size: 72, weight: .thin).monospacedDigit())
                    .foregroundColor(accentColor)
                    .shadow(color: glowColor.opacity(0.4), radius: 12)
                Text("/ \(karmaGoal) 업장소멸")
                    .font(.system(size: 14, weight: .light))
                    .tracking(3)
                    .foregroundColor(accentColor.opacity(0.6))
                if count > 0 {
                    Text("총 \(count)번")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(accentColor.opacity(0.4))
                }
            } else {
                // 공덕: 전체 횟수
                Text("\(count)")
                    .font(.system(size: 72, weight: .thin).monospacedDigit())
                    .foregroundColor(accentColor)
                    .shadow(color: glowColor.opacity(0.4), radius: 12)
                Text("공덕")
                    .font(.system(size: 14, weight: .light))
                    .tracking(4)
                    .foregroundColor(accentColor.opacity(0.6))
            }
        }
    }

    // MARK: - 108번 달성 축하 오버레이
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("🔥")
                    .font(.system(size: 60))
                Text("업장소멸!")
                    .font(.system(size: 32, weight: .medium))
                    .tracking(6)
                    .foregroundColor(accentColor)
                Text("108번 완료 · \(roundsCompleted)순")
                    .font(.system(size: 16, weight: .light))
                    .tracking(2)
                    .foregroundColor(accentColor.opacity(0.7))
                Text("계속 치면 더 소멸됩니다")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white.opacity(0.5))
            }
            .scaleEffect(celebrationScale)
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                show108Celebration = false
            }
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

        // SpriteKit 파티클 방출
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

        // 업장소멸: 108번 달성 체크
        if mode == .karma && count % karmaGoal == 0 {
            roundsCompleted += 1
            // 강한 햅틱
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            // 축하 오버레이 표시
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                show108Celebration = true
                celebrationScale = 1.0
            }
            // 3초 후 자동으로 사라짐
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeOut(duration: 0.3)) {
                    show108Celebration = false
                }
            }
        }
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
    FreePlayView(mode: .karma, onEnd: {})
}
