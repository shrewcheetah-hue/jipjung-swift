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
    case fullMoon = "보름달(望月)"
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
        case .fullMoon: return "보름달의 기운이 가득합니다. 소원을 빌기에 가장 좋은 날입니다."
        case .waningGibbous: return "감사와 성찰의 기운"
        case .lastQuarter: return "내려놓음의 기운"
        case .waningCrescent: return "휴식과 정화의 기운"
        }
    }

    var shortName: String {
        switch self {
        case .newMoon: return "삭"
        case .waxingCrescent: return "초승"
        case .firstQuarter: return "상현"
        case .waxingGibbous: return "보름전"
        case .fullMoon: return "보름"
        case .waningGibbous: return "보름후"
        case .lastQuarter: return "하현"
        case .waningCrescent: return "그믐"
        }
    }

    var qualityLabel: String {
        switch self {
        case .fullMoon: return "최고의 날"
        case .newMoon: return "새 시작"
        case .firstQuarter, .lastQuarter: return "균형의 날"
        case .waxingGibbous: return "성장의 날"
        case .waningGibbous: return "성찰의 날"
        case .waxingCrescent: return "희망의 날"
        case .waningCrescent: return "정화의 날"
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
    let score: Int
}

struct LunarCalendarModel {
    // 오늘의 음력 정보 계산
    static func today() -> LunarDay {
        return lunarDay(for: Date())
    }

    // 특정 날짜의 음력 정보 계산
    static func lunarDay(for date: Date) -> LunarDay {
        let calendar = Calendar(identifier: .chinese)
        var componentSet: Set<Calendar.Component> = [.month, .day]
        if #available(iOS 17, *) {
            componentSet.insert(.isLeapMonth)
        }
        let components = calendar.dateComponents(componentSet, from: date)

        let lunarMonth = components.month ?? 1
        let lunarDayNum = components.day ?? 1
        let isLeap: Bool
        if #available(iOS 17, *) {
            isLeap = components.isLeapMonth ?? false
        } else {
            isLeap = false
        }

        let moonPhase = calculateMoonPhase(lunarDay: lunarDayNum)
        let prayerTimes = calculatePrayerTimes(moonPhase: moonPhase)

        return LunarDay(
            lunarMonth: lunarMonth,
            lunarDay: lunarDayNum,
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

    // 기도하기 좋은 시간 계산 (시진 기반)
    static func calculatePrayerTimes(moonPhase: MoonPhase) -> [PrayerTime] {
        switch moonPhase {
        case .newMoon, .fullMoon:
            return [
                PrayerTime(label: "자시(子時)", time: "23:00", reason: "달이 중천에 뜨는 시간", score: 100),
                PrayerTime(label: "축시(丑時)", time: "01:00", reason: "달의 기운이 가장 강한 시간", score: 92),
                PrayerTime(label: "인시(寅時)", time: "03:00", reason: "새벽 정화의 시간", score: 90),
            ]
        case .firstQuarter, .lastQuarter:
            return [
                PrayerTime(label: "묘시(卯時)", time: "05:00", reason: "새로운 에너지가 시작되는 시간", score: 88),
                PrayerTime(label: "유시(酉時)", time: "17:00", reason: "음양이 균형을 이루는 시간", score: 82),
                PrayerTime(label: "술시(戌時)", time: "19:00", reason: "하루를 마무리하는 성찰의 시간", score: 78),
            ]
        case .waxingCrescent, .waxingGibbous:
            return [
                PrayerTime(label: "진시(辰時)", time: "07:00", reason: "성장의 기운을 받는 시간", score: 85),
                PrayerTime(label: "오시(午時)", time: "11:00", reason: "양기가 가장 강한 시간", score: 80),
                PrayerTime(label: "미시(未時)", time: "13:00", reason: "활력이 넘치는 시간", score: 75),
            ]
        case .waningGibbous, .waningCrescent:
            return [
                PrayerTime(label: "인시(寅時)", time: "03:00", reason: "내려놓음과 정화의 시간", score: 83),
                PrayerTime(label: "해시(亥時)", time: "21:00", reason: "하루를 돌아보는 시간", score: 77),
                PrayerTime(label: "자시(子時)", time: "23:00", reason: "달의 기운이 머무는 시간", score: 72),
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

    // 특정 양력 날짜의 음력 월/일 반환
    static func lunarComponents(for date: Date) -> (month: Int, day: Int) {
        let calendar = Calendar(identifier: .chinese)
        let components = calendar.dateComponents([.month, .day], from: date)
        return (components.month ?? 1, components.day ?? 1)
    }

    // 해당 월의 모든 날짜 배열 반환 (그리드용 - 앞 빈칸 포함)
    static func calendarDays(year: Int, month: Int) -> [Date?] {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // 일요일 시작
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        guard let firstDay = calendar.date(from: components) else { return [] }

        let weekday = calendar.component(.weekday, from: firstDay) // 1=일, 7=토
        let leadingBlanks = weekday - 1

        let range = calendar.range(of: .day, in: .month, for: firstDay)!
        let daysInMonth = range.count

        var result: [Date?] = Array(repeating: nil, count: leadingBlanks)
        for day in 1...daysInMonth {
            components.day = day
            result.append(calendar.date(from: components))
        }
        return result
    }
}
