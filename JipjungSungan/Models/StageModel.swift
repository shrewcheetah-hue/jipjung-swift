import Foundation

// 집중의 순간 - 단계 설정
// 1단계(80bpm) → 2단계(68bpm) → 3단계(56bpm) → 4단계(44bpm) → 5단계(심장 BPM)

typealias Stage = Int

struct StageConfig {
    let stage: Stage
    let bpm: Double
    let hasGuideLight: Bool
    let promoteThreshold: Int
}

let stageConfigs: [StageConfig] = [
    StageConfig(stage: 1, bpm: 80, hasGuideLight: true,  promoteThreshold: 10),
    StageConfig(stage: 2, bpm: 68, hasGuideLight: true,  promoteThreshold: 10),
    StageConfig(stage: 3, bpm: 56, hasGuideLight: false, promoteThreshold: 10),
    StageConfig(stage: 4, bpm: 44, hasGuideLight: false, promoteThreshold: 10),
    StageConfig(stage: 5, bpm: 72, hasGuideLight: true,  promoteThreshold: 999),
]

enum HitResult {
    case perfect, near, off
}

struct PracticeResult {
    var totalHits: Int = 0
    var bestConsecutive: Int = 0
    var stageReached: Stage = 1
    var elapsedSeconds: Int = 0
}
