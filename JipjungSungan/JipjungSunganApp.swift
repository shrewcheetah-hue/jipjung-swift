import SwiftUI
import AVFoundation

// 집중의 순간 - 앱 진입점
// 다크 모드 강제, 오디오 세션 설정

@main
struct JipjungSunganApp: App {
    // WatchConnectivity 세션 초기화 (앱 시작 시 활성화)
    private let watchHeartManager = WatchHeartManager.shared

    init() {
        setupAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오 세션 설정 실패: \(error)")
        }
    }
}
