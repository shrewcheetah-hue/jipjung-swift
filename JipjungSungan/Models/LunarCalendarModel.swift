import Foundation

// 집중의 순간 - 음력 달력 모델
// 음력 날짜 계산 및 달의 위상, 기도 좋은 시간 계산

struct LunarDay {
    let lunarMonth: Int
    let lunarDay: Int
    let isLeapMonth: Bool
    let moonPhase: MoonPhase
    let prayerTimes: [PrayerTime]
}

enum MoonPhase: String {
    case newMoon = "삭"
    case waxingCrescent = "초승달"
    case firstQuarter = "상현달"
    case waxingGibbous = "보름 전"
    case fullMoon = "보름"
    case waningGibbous = "보름 후"
    case lastQuarter = "하현달"
    case waningCrescent = "그믐달"

    var emoji: String {
        switch self {
        case .newMoon: return "🌑"
        case .waxingCrescent: return "🌒"
        case .firstQuarter: return "🌓"
        case .waxingGibbous: return "🌔"
        case .fullMoon: return "🌕"
        case .waningGibbous: return "🌖"
        case .lastQuarter: return "🌗"
        case .waningCrescent: return "🌘"
        }
    }

    var energy: String {
        switch self {
        case .newMoon: return "새로운 시작의 기운"
        case .waxingCrescent: return "성장과 희망의 기운"
        case .firstQuarter: return "결단과 행동의 기운"
        case .waxingGibbous: return "완성을 향한 기운"
        case .fullMoon: return "충만한 달의 기운"
        case .waningGibbous: return "감사와 성찰의 기운"
        case .lastQuarter: return "내려놓음의 기운"
        case .waningCrescent: return "휴식과 정화의 기운"
        }
    }

    var energyEn: String {
        switch self {
        case .newMoon: return "Energy of new beginnings"
        case .waxingCrescent: return "Energy of growth and hope"
        case .firstQuarter: return "Energy of decision and action"
        case .waxingGibbous: return "Energy toward completion"
        case .fullMoon: return "Full lunar energy"
        case .waningGibbous: return "Energy of gratitude and reflection"
        case .lastQuarter: return "Energy of letting go"
        case .waningCrescent: return "Energy of rest and purification"
        }
    }

    func energyLocalized(lang: String) -> String {
        switch lang {
        case "ko": return energy
        default: return energyEn
        }
    }
}

struct PrayerTime {
    let label: String
    let time: String
    let reason: String
}

struct LunarCalendarModel {
    // 오늘의 음력 정보 계산
    static func today() -> LunarDay {
        let calendar = Calendar(identifier: .chinese)
        let now = Date()
        let components = calendar.dateComponents([.month, .day, .isLeapMonth], from: now)

        let lunarMonth = components.month ?? 1
        let lunarDay = components.day ?? 1
        let isLeap = components.isLeapMonth ?? false

        let moonPhase = calculateMoonPhase(lunarDay: lunarDay)
        let prayerTimes = calculatePrayerTimes(moonPhase: moonPhase)

        return LunarDay(
            lunarMonth: lunarMonth,
            lunarDay: lunarDay,
            isLeapMonth: isLeap,
            moonPhase: moonPhase,
            prayerTimes: prayerTimes
        )
    }

    // 음력 날짜로 달의 위상 계산
    static func calculateMoonPhase(lunarDay: Int) -> MoonPhase {
        switch lunarDay {
        case 1: return .newMoon
        case 2...6: return .waxingCrescent
        case 7...8: return .firstQuarter
        case 9...14: return .waxingGibbous
        case 15: return .fullMoon
        case 16...20: return .waningGibbous
        case 21...23: return .lastQuarter
        default: return .waningCrescent
        }
    }

    // 기도하기 좋은 시간 계산
    static func calculatePrayerTimes(moonPhase: MoonPhase) -> [PrayerTime] {
        switch moonPhase {
        case .newMoon, .fullMoon:
            return [
                PrayerTime(label: "새벽", time: "04:00 - 06:00", reason: "달의 기운이 가장 강한 시간"),
                PrayerTime(label: "정오", time: "11:30 - 12:30", reason: "음양의 균형이 맞는 시간"),
                PrayerTime(label: "자정", time: "23:00 - 01:00", reason: "달이 중천에 뜨는 시간"),
            ]
        case .firstQuarter, .lastQuarter:
            return [
                PrayerTime(label: "일출", time: "05:30 - 07:00", reason: "새로운 에너지가 시작되는 시간"),
                PrayerTime(label: "저녁", time: "18:00 - 20:00", reason: "하루를 마무리하는 성찰의 시간"),
            ]
        case .waxingCrescent, .waxingGibbous:
            return [
                PrayerTime(label: "아침", time: "06:00 - 08:00", reason: "성장의 기운을 받는 시간"),
                PrayerTime(label: "오후", time: "14:00 - 16:00", reason: "활력이 넘치는 시간"),
            ]
        case .waningGibbous, .waningCrescent:
            return [
                PrayerTime(label: "새벽", time: "03:00 - 05:00", reason: "내려놓음과 정화의 시간"),
                PrayerTime(label: "밤", time: "21:00 - 23:00", reason: "하루를 돌아보는 시간"),
            ]
        }
    }

    // 자정까지 남은 시간
    static func timeUntilMidnight() -> (hours: Int, minutes: Int, seconds: Int) {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.day! += 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let midnight = calendar.date(from: components) ?? now
        let diff = Int(midnight.timeIntervalSince(now))
        let h = diff / 3600
        let m = (diff % 3600) / 60
        let s = diff % 60
        return (h, m, s)
    }

    // 음력 날짜 표시 문자열
    static func lunarDateString(day: LunarDay) -> String {
        let leap = day.isLeapMonth ? "윤" : ""
        return "음력 \(leap)\(day.lunarMonth)월 \(day.lunarDay)일"
    }
}
