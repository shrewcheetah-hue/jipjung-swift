import SwiftUI

// 집중의 순간 - 앱 루트 뷰
// AppState: 화면 전환 상태 관리

enum AppState {
    case start
    case heartStage
    case practice(stage: Int)
    case result
    case calendar
    case freePlaySelect
    case freePlay(mode: FreePlayMode)
}

struct ContentView: View {
    @StateObject private var engine = RhythmEngine()
    @State private var appState: AppState = .start
    @State private var selectedStage: Int = 1

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            switch appState {
            case .start:
                StartView(
                    onSelectStage: { stage in
                        selectedStage = stage
                        if stage == 5 {
                            appState = .heartStage
                        } else {
                            engine.start(stage: stage)
                            appState = .practice(stage: stage)
                        }
                    },
                    onCalendar: {
                        appState = .calendar
                    },
                    onFreePlay: {
                        appState = .freePlaySelect
                    }
                )

            case .heartStage:
                HeartStageView(
                    onStart: { heartBpm in
                        engine.start(stage: 5, heartBpm: heartBpm)
                        appState = .practice(stage: 5)
                    },
                    onBack: {
                        appState = .start
                    }
                )

            case .practice(let stage):
                PracticeView(
                    engine: engine,
                    stage: stage,
                    onEnd: {
                        engine.stop()
                        appState = .result
                    }
                )

            case .result:
                ResultView(
                    result: engine.practiceResult,
                    onRestart: {
                        appState = .start
                    }
                )

            case .calendar:
                CalendarView(
                    onBack: {
                        appState = .start
                    }
                )

            case .freePlaySelect:
                FreePlaySelectView(
                    onSelect: { mode in
                        appState = .freePlay(mode: mode)
                    },
                    onBack: {
                        appState = .start
                    }
                )

            case .freePlay(let mode):
                FreePlayView(
                    mode: mode,
                    onEnd: {
                        appState = .start
                    }
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
