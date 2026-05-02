import Foundation

// 집중의 순간 - 다국어 지원
// 시스템 언어를 감지해서 ko/en/ja/zh/fr 중 하나를 반환

struct L10n {
    static let shared = L10n()

    private let lang: String

    init() {
        let preferred = Locale.preferredLanguages.first ?? "ko"
        if preferred.hasPrefix("ko") {
            lang = "ko"
        } else if preferred.hasPrefix("ja") {
            lang = "ja"
        } else if preferred.hasPrefix("zh") {
            lang = "zh"
        } else if preferred.hasPrefix("fr") {
            lang = "fr"
        } else {
            lang = "en"
        }
    }

    // MARK: - App
    var appTitle: String {
        switch lang {
        case "ko": return "집중의 순간"
        case "ja": return "集中の瞬間"
        case "zh": return "专注的瞬间"
        case "fr": return "Moment de Concentration"
        default:   return "Moment of Focus"
        }
    }

    var appSubtitle: String {
        switch lang {
        case "ko": return "마음을 고요히"
        case "ja": return "心を静かに"
        case "zh": return "平静心灵"
        case "fr": return "Apaisez votre esprit"
        default:   return "Calm your mind"
        }
    }

    var startDesc1: String {
        switch lang {
        case "ko": return "목탁 소리에 집중하세요"
        case "ja": return "木魚の音に集中してください"
        case "zh": return "专注于木鱼的声音"
        case "fr": return "Concentrez-vous sur le son du moktak"
        default:   return "Focus on the sound of the moktak"
        }
    }

    var startDesc2: String {
        switch lang {
        case "ko": return "내면의 고요함을 찾는 수행"
        case "ja": return "内なる静寂を見つける修行"
        case "zh": return "寻找内心宁静的修行"
        case "fr": return "Une pratique pour trouver la sérénité intérieure"
        default:   return "A practice to find inner stillness"
        }
    }

    var stageLabels: [String] {
        switch lang {
        case "ko": return ["따라", "느껴", "전환", "내면", "심장"]
        case "ja": return ["従う", "感じる", "転換", "内面", "心臓"]
        case "zh": return ["跟随", "感受", "转换", "内心", "心跳"]
        case "fr": return ["Suivre", "Ressentir", "Transition", "Intérieur", "Cœur"]
        default:   return ["Follow", "Feel", "Shift", "Inner", "Heart"]
        }
    }

    var startButton: String {
        switch lang {
        case "ko": return "수행 시작"
        case "ja": return "修行を始める"
        case "zh": return "开始修行"
        case "fr": return "Commencer la pratique"
        default:   return "Begin Practice"
        }
    }

    var calendarButton: String {
        switch lang {
        case "ko": return "🌕  달의 기운"
        case "ja": return "🌕  月のエネルギー"
        case "zh": return "🌕  月亮能量"
        case "fr": return "🌕  Énergie lunaire"
        default:   return "🌕  Lunar Energy"
        }
    }

    // MARK: - Practice
    var hudTime: String {
        switch lang {
        case "ko": return "시간"
        case "ja": return "時間"
        case "zh": return "时间"
        case "fr": return "Temps"
        default:   return "Time"
        }
    }

    var hudToday: String {
        switch lang {
        case "ko": return "오늘"
        case "ja": return "今日"
        case "zh": return "今天"
        case "fr": return "Aujourd'hui"
        default:   return "Today"
        }
    }

    func consecutive(_ n: Int) -> String {
        switch lang {
        case "ko": return "연속 \(n)회"
        case "ja": return "\(n)連続"
        case "zh": return "连续\(n)次"
        case "fr": return "\(n) en série"
        default:   return "\(n) in a row"
        }
    }

    func promoteLabel(_ n: Int) -> String {
        switch lang {
        case "ko": return "다음 단계까지 \(n)회"
        case "ja": return "次のステージまであと\(n)回"
        case "zh": return "距下一阶段还需\(n)次"
        case "fr": return "\(n) de plus pour le prochain niveau"
        default:   return "\(n) more to next stage"
        }
    }

    var endButton: String {
        switch lang {
        case "ko": return "종료하기"
        case "ja": return "終了する"
        case "zh": return "结束"
        case "fr": return "Terminer"
        default:   return "End"
        }
    }

    var stageDescriptions: [String] {
        switch lang {
        case "ko": return ["템포를 따라 쳐주세요", "소리를 느끼며 쳐주세요", "진동을 느끼며 쳐주세요", "내 안의 리듬으로 쳐주세요", "심장의 리듬으로 쳐주세요"]
        case "ja": return ["テンポに合わせて叩いてください", "音を感じながら叩いてください", "振動を感じながら叩いてください", "内なるリズムで叩いてください", "心臓のリズムで叩いてください"]
        case "zh": return ["跟随节拍敲击", "感受声音敲击", "感受振动敲击", "用内心的节奏敲击", "用心跳的节奏敲击"]
        case "fr": return ["Suivez le tempo", "Ressentez le son", "Ressentez la vibration", "Suivez votre rythme intérieur", "Suivez votre rythme cardiaque"]
        default:   return ["Follow the tempo", "Feel the sound", "Feel the vibration", "Follow your inner rhythm", "Follow your heartbeat"]
        }
    }

    var stageNames: [String] {
        switch lang {
        case "ko": return ["1단계", "2단계", "3단계", "4단계", "5단계"]
        case "ja": return ["第1段階", "第2段階", "第3段階", "第4段階", "第5段階"]
        case "zh": return ["第1阶段", "第2阶段", "第3阶段", "第4阶段", "第5阶段"]
        case "fr": return ["Étape 1", "Étape 2", "Étape 3", "Étape 4", "Étape 5"]
        default:   return ["Stage 1", "Stage 2", "Stage 3", "Stage 4", "Stage 5"]
        }
    }

    // MARK: - Heart Stage
    var heartTitle: String {
        switch lang {
        case "ko": return "5단계 · 심장의 리듬"
        case "ja": return "第5段階 · 心臓のリズム"
        case "zh": return "第5阶段 · 心跳节奏"
        case "fr": return "Étape 5 · Rythme cardiaque"
        default:   return "Stage 5 · Heart Rhythm"
        }
    }

    var heartSubtitle: String {
        switch lang {
        case "ko": return "내 심장이 목탁을 칩니다"
        case "ja": return "私の心臓が木魚を叩きます"
        case "zh": return "我的心跳敲响木鱼"
        case "fr": return "Mon cœur frappe le moktak"
        default:   return "My heart strikes the moktak"
        }
    }

    var heartDesc: String {
        switch lang {
        case "ko": return "심장 박동에 맞춰 화면을 탭하세요.\n측정된 BPM으로 목탁이 울립니다."
        case "ja": return "心拍に合わせて画面をタップしてください。\n測定されたBPMで木魚が鳴ります。"
        case "zh": return "按照心跳节奏点击屏幕。\n木鱼将以您的BPM鸣响。"
        case "fr": return "Tapez sur l'écran au rythme de votre cœur.\nLe moktak sonnera à votre BPM."
        default:   return "Tap the screen to your heartbeat.\nThe moktak will sound at your BPM."
        }
    }

    var heartTapButton: String {
        switch lang {
        case "ko": return "심박에 맞춰 탭하기"
        case "ja": return "心拍に合わせてタップ"
        case "zh": return "按心跳节奏点击"
        case "fr": return "Taper au rythme cardiaque"
        default:   return "Tap to your heartbeat"
        }
    }

    func heartStartButton(bpm: Int?) -> String {
        if let bpm = bpm {
            switch lang {
            case "ko": return "\(bpm) BPM으로 수행 시작"
            case "ja": return "\(bpm) BPMで修行を始める"
            case "zh": return "以\(bpm) BPM开始修行"
            case "fr": return "Commencer à \(bpm) BPM"
            default:   return "Start at \(bpm) BPM"
            }
        } else {
            switch lang {
            case "ko": return "먼저 심박수를 측정하세요"
            case "ja": return "まず心拍数を測定してください"
            case "zh": return "请先测量心率"
            case "fr": return "Mesurez d'abord votre fréquence cardiaque"
            default:   return "Measure your heart rate first"
            }
        }
    }

    var heartNote: String {
        switch lang {
        case "ko": return "실시간 심박수로 목탁이 자동으로 울립니다."
        case "ja": return "リアルタイムの心拍数で木魚が自動的に鳴ります。"
        case "zh": return "木鱼将自动以您的实时心率鸣响。"
        case "fr": return "Le moktak sonnera automatiquement à votre fréquence cardiaque en temps réel."
        default:   return "The moktak will automatically sound at your real-time heart rate."
        }
    }

    // MARK: - Result
    var resultTitle: String {
        switch lang {
        case "ko": return "수행 완료"
        case "ja": return "修行完了"
        case "zh": return "修行完成"
        case "fr": return "Pratique terminée"
        default:   return "Practice Complete"
        }
    }

    var resultSubtitle: String {
        switch lang {
        case "ko": return "오늘의 수행이 마음에 고요함을 가져다주길"
        case "ja": return "今日の修行が心に静寂をもたらしますように"
        case "zh": return "愿今日的修行为您的心灵带来宁静"
        case "fr": return "Que la pratique d'aujourd'hui apporte la sérénité à votre esprit"
        default:   return "May today's practice bring stillness to your mind"
        }
    }

    var statTotalHits: String {
        switch lang {
        case "ko": return "수행 횟수"
        case "ja": return "修行回数"
        case "zh": return "修行次数"
        case "fr": return "Total de frappes"
        default:   return "Total Hits"
        }
    }

    var statBestConsecutive: String {
        switch lang {
        case "ko": return "최고 연속"
        case "ja": return "最高連続"
        case "zh": return "最高连续"
        case "fr": return "Meilleure série"
        default:   return "Best Streak"
        }
    }

    var statStageReached: String {
        switch lang {
        case "ko": return "도달 단계"
        case "ja": return "到達段階"
        case "zh": return "到达阶段"
        case "fr": return "Étape atteinte"
        default:   return "Stage Reached"
        }
    }

    var statPracticeTime: String {
        switch lang {
        case "ko": return "수행 시간"
        case "ja": return "修行時間"
        case "zh": return "修行时间"
        case "fr": return "Temps de pratique"
        default:   return "Practice Time"
        }
    }

    var resultMessages: [String] {
        switch lang {
        case "ko": return [
            "내면의 리듬을 찾았습니다. 훌륭합니다.",
            "고요함에 가까워지고 있습니다.",
            "꾸준한 수행이 마음을 엽니다.",
            "첫 수행을 완료했습니다. 내일도 함께해요.",
        ]
        case "ja": return [
            "内なるリズムを見つけました。素晴らしい。",
            "静寂に近づいています。",
            "継続的な修行が心を開きます。",
            "最初の修行を完了しました。明日もご一緒に。",
        ]
        case "zh": return [
            "您找到了内心的节奏。太棒了。",
            "您正在接近宁静。",
            "持续的修行开启心灵。",
            "您完成了第一次修行。明天见。",
        ]
        case "fr": return [
            "Vous avez trouvé votre rythme intérieur. Excellent.",
            "Vous vous rapprochez de la sérénité.",
            "Une pratique régulière ouvre l'esprit.",
            "Vous avez terminé votre première session. À demain.",
        ]
        default: return [
            "You found your inner rhythm. Excellent.",
            "You are approaching stillness.",
            "Consistent practice opens the mind.",
            "You completed your first session. See you tomorrow.",
        ]
        }
    }

    var restartButton: String {
        switch lang {
        case "ko": return "다시 수행하기"
        case "ja": return "もう一度修行する"
        case "zh": return "再次修行"
        case "fr": return "Pratiquer à nouveau"
        default:   return "Practice Again"
        }
    }

    // MARK: - Calendar
    var calendarTodayEnergy: String {
        switch lang {
        case "ko": return "오늘의 달 기운"
        case "ja": return "今日の月のエネルギー"
        case "zh": return "今日月亮能量"
        case "fr": return "Énergie lunaire d'aujourd'hui"
        default:   return "Today's Lunar Energy"
        }
    }

    var calendarUntilMidnight: String {
        switch lang {
        case "ko": return "오늘 자정까지"
        case "ja": return "今日の深夜まで"
        case "zh": return "今日午夜前"
        case "fr": return "Jusqu'à minuit"
        default:   return "Until midnight"
        }
    }

    var calendarBestTime: String {
        switch lang {
        case "ko": return "오늘 기도하기 좋은 시간"
        case "ja": return "今日の祈りに良い時間"
        case "zh": return "今日祈祷的好时间"
        case "fr": return "Meilleur moment pour prier aujourd'hui"
        default:   return "Best time to pray today"
        }
    }

    var calendarBestTimeTitle: String {
        switch lang {
        case "ko": return "기도하기 좋은 시간"
        case "ja": return "祈りに良い時間"
        case "zh": return "祈祷好时间"
        case "fr": return "Meilleur moment de prière"
        default:   return "Best Prayer Time"
        }
    }
}

// 전역 접근 편의
let t = L10n.shared
