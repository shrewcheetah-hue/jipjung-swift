import SwiftUI

// 집중의 순간 - 달의 기운 달력 화면
// 월별 달력 그리드 + 달 위상 이모지 + 선택 날짜 기운 카드

struct CalendarView: View {
    let onBack: () -> Void

    @State private var todayLunarDay = LunarCalendarModel.today()
    @State private var countdown = LunarCalendarModel.timeUntilMidnight()
    @State private var countdownTimer: Timer? = nil
    @State private var appear = false

    // 달력 상태
    @State private var displayYear: Int = Calendar.current.component(.year, from: Date())
    @State private var displayMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDate: Date = Date()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // 뒤로가기
                    HStack {
                        Button(action: onBack) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14))
                                Text("뒤로")
                                    .font(.system(size: 14, weight: .light))
                            }
                            .foregroundColor(AppColors.white50)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                    Spacer().frame(height: 16)

                    // 월 네비게이션
                    monthNavigationHeader

                    Spacer().frame(height: 12)

                    // 요일 헤더
                    weekdayHeader

                    Spacer().frame(height: 8)

                    // 달력 그리드
                    calendarGrid

                    Spacer().frame(height: 24)

                    // 선택 날짜 기운 카드
                    selectedDateCard

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, 16)
            }
        }
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.easeIn(duration: 0.4)) {
                appear = true
            }
            startCountdownTimer()
        }
        .onDisappear {
            countdownTimer?.invalidate()
        }
    }

    // MARK: - Month Navigation Header
    private var monthNavigationHeader: some View {
        HStack {
            Button(action: prevMonth) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .frame(width: 36, height: 36)
            }

            Spacer()

            Text("\(displayYear)년 \(displayMonth)월")
                .font(.system(size: 18, weight: .thin))
                .foregroundColor(AppColors.white80)
                .tracking(2)

            Spacer()

            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(AppColors.white50)
                    .frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Weekday Header
    private var weekdayHeader: some View {
        let days = ["일", "월", "화", "수", "목", "금", "토"]
        return HStack(spacing: 0) {
            ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                Text(day)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(index == 0 ? AppColors.red : AppColors.white50)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        let days = LunarCalendarModel.calendarDays(year: displayYear, month: displayMonth)
        let rows = stride(from: 0, to: days.count, by: 7).map { Array(days[$0..<min($0 + 7, days.count)]) }

        return VStack(spacing: 4) {
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \.self) { col in
                        let date = col < row.count ? row[col] : nil
                        CalendarDayCell(
                            date: date,
                            isToday: isToday(date),
                            isSelected: isSelected(date),
                            isSunday: col == 0,
                            onTap: { if let d = date { selectedDate = d } }
                        )
                    }
                }
            }
        }
    }

    // MARK: - Selected Date Card
    private var selectedDateCard: some View {
        let lunar = LunarCalendarModel.lunarDay(for: selectedDate)
        let cal = Calendar.current
        let selMonth = cal.component(.month, from: selectedDate)
        let selDay = cal.component(.day, from: selectedDate)

        return VStack(alignment: .leading, spacing: 0) {
            // 날짜 레이블
            Text("\(selMonth)월 \(selDay)일의 기운")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(AppColors.white50)
                .tracking(1)
                .padding(.bottom, 14)

            // 카드
            VStack(alignment: .leading, spacing: 14) {
                // 달 이름 + 음력 날짜 + 품질 레이블
                HStack(alignment: .center, spacing: 12) {
                    Text(lunar.moonPhase.emoji)
                        .font(.system(size: 44))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(lunar.moonPhase.rawValue)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundColor(AppColors.gold)

                        Text("음력 \(lunar.lunarMonth)월 \(lunar.lunarDay)일")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(AppColors.white50)
                    }

                    Spacer()

                    Text(lunar.moonPhase.qualityLabel)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppColors.gold)
                }

                // 기운 설명
                Text(lunar.moonPhase.energy)
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(AppColors.white80)
                    .lineSpacing(4)

                // 구분선
                Rectangle()
                    .fill(AppColors.white10)
                    .frame(height: 1)

                // 기도 시간 목록
                VStack(alignment: .leading, spacing: 0) {
                    Text("기도하기 좋은 시간")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(AppColors.white30)
                        .tracking(1)
                        .padding(.bottom, 10)

                    ForEach(lunar.prayerTimes, id: \.label) { pt in
                        HStack {
                            Text(pt.time)
                                .font(.system(size: 14, weight: .light, design: .monospaced))
                                .foregroundColor(AppColors.white50)
                                .frame(width: 52, alignment: .leading)

                            Text(pt.label)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(AppColors.white80)

                            Spacer()

                            Text("\(pt.score)점")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(AppColors.gold)
                        }
                        .padding(.vertical, 8)

                        if pt.label != lunar.prayerTimes.last?.label {
                            Rectangle()
                                .fill(AppColors.white10)
                                .frame(height: 0.5)
                        }
                    }
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.darkCopper, lineWidth: 1)
                    )
            )

            // 오늘인 경우 자정 카운트다운 추가
            if isToday(selectedDate) {
                Spacer().frame(height: 14)
                countdownSection
            }
        }
    }

    // MARK: - Countdown Section
    private var countdownSection: some View {
        VStack(spacing: 10) {
            Text("자정까지")
                .font(.system(size: 12, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(1)

            HStack(spacing: 12) {
                CountdownUnit(value: countdown.hours, unit: "시간")
                Text(":")
                    .font(.system(size: 18, weight: .thin))
                    .foregroundColor(AppColors.white30)
                CountdownUnit(value: countdown.minutes, unit: "분")
                Text(":")
                    .font(.system(size: 18, weight: .thin))
                    .foregroundColor(AppColors.white30)
                CountdownUnit(value: countdown.seconds, unit: "초")
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.darkCopper, lineWidth: 1)
                )
        )
    }

    // MARK: - Helpers
    private func isToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDateInToday(date)
    }

    private func isSelected(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    private func prevMonth() {
        var m = displayMonth - 1
        var y = displayYear
        if m < 1 { m = 12; y -= 1 }
        displayMonth = m
        displayYear = y
    }

    private func nextMonth() {
        var m = displayMonth + 1
        var y = displayYear
        if m > 12 { m = 1; y += 1 }
        displayMonth = m
        displayYear = y
    }

    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            countdown = LunarCalendarModel.timeUntilMidnight()
        }
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date?
    let isToday: Bool
    let isSelected: Bool
    let isSunday: Bool
    let onTap: () -> Void

    private var lunarDayNum: Int {
        guard let date = date else { return 0 }
        return LunarCalendarModel.lunarComponents(for: date).day
    }

    private var moonPhase: MoonPhase {
        LunarCalendarModel.calculateMoonPhase(lunarDay: lunarDayNum)
    }

    private var dayNumber: Int {
        guard let date = date else { return 0 }
        return Calendar.current.component(.day, from: date)
    }

    var body: some View {
        if date == nil {
            Color.clear
                .frame(maxWidth: .infinity)
                .frame(height: 72)
        } else {
            Button(action: onTap) {
                VStack(spacing: 3) {
                    ZStack {
                        // 오늘 날짜 금색 테두리
                        if isToday {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(AppColors.gold, lineWidth: 1.5)
                                .frame(width: 32, height: 32)
                        }
                        // 선택된 날짜 반투명 배경
                        if isSelected && !isToday {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(AppColors.metallicBronzeAlpha15)
                                .frame(width: 32, height: 32)
                        }

                        Text("\(dayNumber)")
                            .font(.system(size: 14, weight: isToday ? .medium : .light))
                            .foregroundColor(
                                isToday ? AppColors.gold :
                                isSunday ? AppColors.red :
                                AppColors.white80
                            )
                    }
                    .frame(width: 32, height: 32)

                    // 달 위상 이모지
                    Text(moonPhase.emoji)
                        .font(.system(size: 16))

                    // 보름달/삭 날에 점 표시
                    if moonPhase == .fullMoon || moonPhase == .newMoon {
                        Circle()
                            .fill(moonPhase == .fullMoon ? AppColors.gold : AppColors.white30)
                            .frame(width: 4, height: 4)
                    } else {
                        Color.clear.frame(height: 4)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 72)
            }
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Countdown Unit Component
struct CountdownUnit: View {
    let value: Int
    let unit: String

    var body: some View {
        VStack(spacing: 2) {
            Text(String(format: "%02d", value))
                .font(.system(size: 26, weight: .thin, design: .monospaced))
                .foregroundColor(AppColors.white80)

            Text(unit)
                .font(.system(size: 10, weight: .light))
                .foregroundColor(AppColors.white30)
        }
    }
}

// MARK: - Prayer Time Row Component
struct PrayerTimeRow: View {
    let prayerTime: PrayerTime

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(prayerTime.label)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.white80)

                    Text(prayerTime.time)
                        .font(.system(size: 13, weight: .light, design: .monospaced))
                        .foregroundColor(AppColors.gold)
                }

                Text(prayerTime.reason)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white30)
            }

            Spacer()

            Image(systemName: "moon.stars")
                .font(.system(size: 14))
                .foregroundColor(AppColors.goldDim)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(AppColors.metallicBronzeAlpha15)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(AppColors.darkCopper, lineWidth: 1)
                )
        )
    }
}

#Preview {
    CalendarView(onBack: {})
        .preferredColorScheme(.dark)
}
