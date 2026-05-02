import SwiftUI

// 집중의 순간 - 달의 기운 달력 화면
// 오늘의 달 위상, 음력 날짜, 자정 카운트다운, 기도 좋은 시간

struct CalendarView: View {
    let onBack: () -> Void

    @State private var lunarDay = LunarCalendarModel.today()
    @State private var countdown = LunarCalendarModel.timeUntilMidnight()
    @State private var countdownTimer: Timer? = nil
    @State private var appear = false

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
                    .padding(.horizontal, 24)

                    Spacer().frame(height: 32)

                    // 타이틀
                    VStack(spacing: 6) {
                        Text(t.calendarTodayEnergy)
                            .font(.system(size: 20, weight: .thin))
                            .foregroundColor(AppColors.gold)
                            .tracking(3)

                        Text(LunarCalendarModel.lunarDateString(day: lunarDay))
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(AppColors.white30)
                            .tracking(1)
                    }

                    Spacer().frame(height: 40)

                    // 달 위상 표시
                    moonPhaseSection

                    Spacer().frame(height: 32)

                    // 달 기운 설명
                    energySection

                    Spacer().frame(height: 28)

                    // 자정까지 카운트다운
                    countdownSection

                    Spacer().frame(height: 28)

                    // 기도 좋은 시간
                    prayerTimesSection

                    Spacer().frame(height: 60)
                }
                .padding(.horizontal, 28)
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

    // MARK: - Moon Phase Section
    private var moonPhaseSection: some View {
        VStack(spacing: 16) {
            // 달 이모지 (크게)
            Text(lunarDay.moonPhase.emoji)
                .font(.system(size: 72))

            Text(lunarDay.moonPhase.rawValue)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(AppColors.white80)
                .tracking(2)
        }
    }

    // MARK: - Energy Section
    private var energySection: some View {
        VStack(spacing: 12) {
            Text(lunarDay.moonPhase.energy)
                .font(.system(size: 15, weight: .light))
                .foregroundColor(AppColors.gold)
                .multilineTextAlignment(.center)
                .tracking(1)

            // 음력 날짜 기반 에너지 강도 바
            energyBar
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.surface)
        )
    }

    private var energyBar: some View {
        let intensity = moonPhaseIntensity(lunarDay.moonPhase)
        return VStack(spacing: 6) {
            HStack {
                Text("기운 강도")
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(AppColors.white30)
                Spacer()
                Text("\(Int(intensity * 100))%")
                    .font(.system(size: 11, weight: .light, design: .monospaced))
                    .foregroundColor(AppColors.goldDim)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.white10)
                        .frame(height: 4)

                    RoundedRectangle(cornerRadius: 2)
                        .fill(AppColors.gold)
                        .frame(width: geo.size.width * CGFloat(intensity), height: 4)
                }
            }
            .frame(height: 4)
        }
    }

    // MARK: - Countdown Section
    private var countdownSection: some View {
        VStack(spacing: 12) {
            Text(t.calendarUntilMidnight)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(AppColors.white30)
                .tracking(1)

            HStack(spacing: 16) {
                CountdownUnit(value: countdown.hours, unit: "시간")
                Text(":")
                    .font(.system(size: 20, weight: .thin))
                    .foregroundColor(AppColors.white30)
                CountdownUnit(value: countdown.minutes, unit: "분")
                Text(":")
                    .font(.system(size: 20, weight: .thin))
                    .foregroundColor(AppColors.white30)
                CountdownUnit(value: countdown.seconds, unit: "초")
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.surface)
        )
    }

    // MARK: - Prayer Times Section
    private var prayerTimesSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(t.calendarBestTimeTitle)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(AppColors.gold)
                    .tracking(1)
                Spacer()
            }

            ForEach(lunarDay.prayerTimes, id: \.label) { prayerTime in
                PrayerTimeRow(prayerTime: prayerTime)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColors.surface)
        )
    }

    // MARK: - Helpers
    private func moonPhaseIntensity(_ phase: MoonPhase) -> Double {
        switch phase {
        case .fullMoon: return 1.0
        case .waxingGibbous, .waningGibbous: return 0.8
        case .firstQuarter, .lastQuarter: return 0.6
        case .waxingCrescent, .waningCrescent: return 0.4
        case .newMoon: return 0.2
        }
    }

    private func startCountdownTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            countdown = LunarCalendarModel.timeUntilMidnight()
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
                .font(.system(size: 28, weight: .thin, design: .monospaced))
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
                .fill(AppColors.goldAlpha08)
        )
    }
}

#Preview {
    CalendarView(onBack: {})
        .preferredColorScheme(.dark)
}
