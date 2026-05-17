import SwiftUI
import SpriteKit
import AVFoundation

// 자유치기 수행 화면
// 공덕: 자유롭게 / 업장소멸: 108번 탭 = 업장소멸 1번
struct FreePlayView: View {
    let mode: FreePlayMode
    let onEnd: () -> Void

    @State private var tapCount: Int = 0          // 총 탭 횟수
    @State private var karmaCount: Int = 0        // 업장소멸 완료 횟수 (108번마다 +1)
    @State private var tapScale: CGFloat = 1.0
    @State private var tapGlow: CGFloat = 0.0
    @State private var elapsedSeconds: Int = 0
    @State private var timer: Timer? = nil
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showEndConfirm = false

    // 업장소멸 달성 축하
    @State private var show108Celebration = false
    @State private var celebrationScale: CGFloat = 0.5

    // SpriteKit 씬
    @State private var meritScene = MeritParticleScene()
    @State private var karmaScene = KarmaParticleScene()

    private let karmaGoal = 108

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

    // 현재 라운드 내 탭 횟수
    private var currentTapInRound: Int {
        tapCount % karmaGoal
    }
    // 진행률 0~1
    private var karmaProgress: CGFloat {
        CGFloat(currentTapInRound) / CGFloat(karmaGoal)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                bgColor.ignoresSafeArea()

                SpriteView(scene: mode == .merit ? meritScene : karmaScene,
                           options: [.allowsTransparency])
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                VStack(spacing: 0) {
                    topBar
                    Spacer()
                    moktakArea(geo: geo)
                    Spacer()
                    countDisplay
                    Spacer(minLength: 40)
                    endButton.padding(.bottom, 40)
                }

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
            .onDisappear { timer?.invalidate() }
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
            if mode == .karma {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("업장소멸 \(karmaCount)번")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(accentColor)
                    Text("목탁 \(tapCount)회")
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(accentColor.opacity(0.5))
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
            if mode == .karma {
                Circle()
                    .stroke(accentColor.opacity(0.12), lineWidth: 3)
                    .frame(width: size * 1.15, height: size * 1.15)

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

                VStack(spacing: 2) {
                    let remaining = karmaGoal - currentTapInRound
                    Text("\(remaining)")
                        .font(.system(size: 13, weight: .light).monospacedDigit())
                        .foregroundColor(accentColor.opacity(0.7))
                    Text("번 남음")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(accentColor.opacity(0.4))
                }
                .offset(y: size * 0.72)
            }

            Circle()
                .fill(glowColor.opacity(0.08 + tapGlow * 0.18))
                .frame(width: size * 1.4, height: size * 1.4)
                .blur(radius: 30)

            Image("moktak")
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .scaleEffect(tapScale)
                .shadow(color: glowColor.opacity(0.3 + tapGlow * 0.5), radius: 20 + tapGlow * 30)
        }
        .frame(width: size * 1.5, height: size * 1.5)
        .contentShape(Rectangle())
        .onTapGesture { handleTap(in: geo) }
    }

    // MARK: - Count Display
    private var countDisplay: some View {
        VStack(spacing: 6) {
            if mode == .karma {
                Text("\(karmaCount)")
                    .font(.system(size: 72, weight: .thin).monospacedDigit())
                    .foregroundColor(accentColor)
                    .shadow(color: glowColor.opacity(0.4), radius: 12)
                Text("업장소멸")
                    .font(.system(size: 14, weight: .light))
                    .tracking(4)
                    .foregroundColor(accentColor.opacity(0.6))
                Text("이번 \(currentTapInRound) / 108")
                    .font(.system(size: 13, weight: .light).monospacedDigit())
                    .foregroundColor(accentColor.opacity(0.4))
                    .padding(.top, 4)
            } else {
                Text("\(tapCount)")
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

    // MARK: - 달성 축하 오버레이
    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.65).ignoresSafeArea()
            VStack(spacing: 20) {
                Text("🔥")
                    .font(.system(size: 64))
                Text("업장소멸 \(karmaCount)번!")
                    .font(.system(size: 30, weight: .medium))
                    .tracking(4)
                    .foregroundColor(accentColor)
                Text("목탁 108번으로\n업장 하나를 소멸했습니다")
                    .font(.system(size: 15, weight: .light))
                    .tracking(1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.7))
                Text("화면을 탭하면 계속됩니다")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.white.opacity(0.4))
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
        tapCount += 1
        playSound()

        withAnimation(.easeOut(duration: 0.07)) { tapScale = 0.92; tapGlow = 1.0 }
        withAnimation(.easeIn(duration: 0.18).delay(0.07)) { tapScale = 1.0; tapGlow = 0.0 }

        let skPoint = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
        if mode == .merit {
            meritScene.burst(at: skPoint)
        } else {
            karmaScene.burst(at: skPoint)
        }

        let impact = UIImpactFeedbackGenerator(style: mode == .merit ? .light : .medium)
        impact.impactOccurred()

        // 108번마다 업장소멸 1번 완료
        if mode == .karma && tapCount % karmaGoal == 0 {
            karmaCount += 1
            let notification = UINotificationFeedbackGenerator()
            notification.notificationOccurred(.success)
            celebrationScale = 0.5
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                show108Celebration = true
                celebrationScale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
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
        String(format: "%02d:%02d", elapsedSeconds / 60, elapsedSeconds % 60)
    }
}

#Preview {
    FreePlayView(mode: .karma, onEnd: {})
}
