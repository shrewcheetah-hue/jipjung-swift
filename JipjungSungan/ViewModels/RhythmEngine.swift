import Foundation
import AVFoundation
import UIKit
import Combine

// 집중의 순간 - 리듬 엔진
// - 박자 루프: 가이드 빛만 (소리/진동 없음)
// - 탭 시: 소리 + 진동 (4단계 제외 소리)
// - Perfect window: 12%, Near window: 25%

private let perfectWindow = 0.12
private let nearWindow = 0.25

class RhythmEngine: ObservableObject {
    // MARK: - Published State
    @Published var stage: Stage = 1
    @Published var bpm: Double = 80
    @Published var isRunning: Bool = false
    @Published var totalHits: Int = 0
    @Published var consecutiveHits: Int = 0
    @Published var bestConsecutive: Int = 0
    @Published var promoteProgress: Double = 0
    @Published var elapsedSeconds: Int = 0
    @Published var lastHitResult: HitResult? = nil
    @Published var guideBeat: Bool = false
    @Published var ringProgress: Double = 0
    @Published var heartBpm: Double? = nil

    // MARK: - Private
    private var currentStageIndex: Int = 0
    private var beatInterval: TimeInterval = 60.0 / 80.0
    private var lastBeatTime: Date = Date()
    private var beatTimer: Timer?
    private var ringTimer: Timer?
    private var elapsedTimer: Timer?
    private var audioPlayer: AVAudioPlayer?
    private var promoteLocked: Bool = false

    // MARK: - Start
    func start(stage: Stage = 1, heartBpm: Double? = nil) {
        let config = stageConfigs[stage - 1]
        let actualBpm = (stage == 5 && heartBpm != nil) ? heartBpm! : config.bpm

        self.stage = stage
        self.currentStageIndex = stage - 1
        self.bpm = actualBpm
        self.isRunning = true
        self.totalHits = 0
        self.consecutiveHits = 0
        self.bestConsecutive = 0
        self.promoteProgress = 0
        self.elapsedSeconds = 0
        self.lastHitResult = nil
        self.guideBeat = false
        self.ringProgress = 0
        self.heartBpm = heartBpm
        self.promoteLocked = false

        prepareAudio(stage: stage)
        startBeatLoop(bpm: actualBpm)
        startElapsedTimer()
    }

    // MARK: - Stop
    func stop() {
        beatTimer?.invalidate()
        ringTimer?.invalidate()
        elapsedTimer?.invalidate()
        beatTimer = nil
        ringTimer = nil
        elapsedTimer = nil
        isRunning = false
    }

    // MARK: - On Hit (탭)
    func onHit() {
        guard isRunning else { return }

        // 소리 재생 (4단계 제외)
        if stage != 4 {
            playSound()
        }

        // 진동
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // 타이밍 판정
        let now = Date()
        let timeSinceLastBeat = now.timeIntervalSince(lastBeatTime)
        let distFromBeat = min(timeSinceLastBeat, beatInterval - timeSinceLastBeat)
        let ratio = distFromBeat / beatInterval

        let hitResult: HitResult
        if ratio <= perfectWindow {
            hitResult = .perfect
        } else if ratio <= nearWindow {
            hitResult = .near
        } else {
            hitResult = .off
        }

        // 상태 업데이트
        totalHits += 1
        if hitResult == .perfect {
            consecutiveHits += 1
            if consecutiveHits > bestConsecutive {
                bestConsecutive = consecutiveHits
            }
            promoteProgress = min(promoteProgress + 1, Double(stageConfigs[currentStageIndex].promoteThreshold))
        } else {
            consecutiveHits = 0
            promoteProgress = max(promoteProgress - 0.5, 0)
        }

        lastHitResult = hitResult

        // 진급 체크
        if !promoteLocked && promoteProgress >= Double(stageConfigs[currentStageIndex].promoteThreshold) && stage < 5 {
            promoteLocked = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                let nextStage = self.stage + 1
                let nextConfig = stageConfigs[nextStage - 1]
                self.stage = nextStage
                self.currentStageIndex = nextStage - 1
                self.bpm = nextConfig.bpm
                self.promoteProgress = 0
                self.consecutiveHits = 0
                self.lastHitResult = nil
                self.promoteLocked = false
                self.prepareAudio(stage: nextStage)
                self.startBeatLoop(bpm: nextConfig.bpm)
            }
        }

        // 히트 결과 초기화
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.lastHitResult = nil
        }
    }

    // MARK: - Update Heart BPM
    func updateHeartBpm(_ bpm: Double) {
        heartBpm = bpm
        if stage == 5 && isRunning {
            self.bpm = bpm
            startBeatLoop(bpm: bpm)
        }
    }

    // MARK: - Private Helpers
    private func startBeatLoop(bpm: Double) {
        beatTimer?.invalidate()
        ringTimer?.invalidate()

        beatInterval = 60.0 / bpm
        lastBeatTime = Date()

        beatTimer = Timer.scheduledTimer(withTimeInterval: beatInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.lastBeatTime = Date()
            self.guideBeat = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                self.guideBeat = false
            }
        }

        // 60fps 링 진행도 업데이트
        ringTimer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = Date().timeIntervalSince(self.lastBeatTime)
            self.ringProgress = min(elapsed / self.beatInterval, 1.0)
        }
    }

    private func startElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
    }

    private func prepareAudio(stage: Stage) {
        // 목탁 소리 - 번들에 moktak.mp3 또는 moktak.wav 파일 필요
        // 없을 경우 시스템 사운드 사용
        if let url = Bundle.main.url(forResource: "moktak", withExtension: "mp3") ??
                     Bundle.main.url(forResource: "moktak", withExtension: "wav") {
            audioPlayer = try? AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
        }
    }

    private func playSound() {
        if let player = audioPlayer {
            player.currentTime = 0
            player.play()
        } else {
            // 소리 파일 없을 때 시스템 사운드 (클릭음)
            AudioServicesPlaySystemSound(1104)
        }
    }

    // MARK: - Computed
    var practiceResult: PracticeResult {
        PracticeResult(
            totalHits: totalHits,
            bestConsecutive: bestConsecutive,
            stageReached: stage,
            elapsedSeconds: elapsedSeconds
        )
    }

    var promoteRemaining: Int {
        max(stageConfigs[currentStageIndex].promoteThreshold - Int(promoteProgress), 0)
    }

    var elapsedFormatted: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
