import Foundation
import HealthKit
import WatchConnectivity

// 집중의 순간 Watch - 심박수 측정 및 iPhone 전송 매니저
// HealthKit으로 실시간 심박수 측정 → WatchConnectivity로 iPhone에 전송
class HeartRateManager: NSObject, ObservableObject {

    private let healthStore = HKHealthStore()
    private var query: HKAnchoredObjectQuery?

    @Published var currentBPM: Double? = nil
    @Published var isAuthorized: Bool = false
    @Published var isMonitoring: Bool = false

    override init() {
        super.init()
        setupWatchConnectivity()
    }

    // MARK: - WatchConnectivity 설정
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // MARK: - HealthKit 권한 요청
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false)
            return
        }
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        healthStore.requestAuthorization(toShare: nil, read: [heartRateType]) { [weak self] success, _ in
            DispatchQueue.main.async {
                self?.isAuthorized = success
                completion(success)
            }
        }
    }

    // MARK: - 심박수 모니터링 시작
    func startMonitoring() {
        guard isAuthorized else {
            requestAuthorization { [weak self] success in
                if success { self?.startMonitoring() }
            }
            return
        }

        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let predicate = HKQuery.predicateForSamples(withStart: Date(), end: nil, options: .strictStartDate)

        query = HKAnchoredObjectQuery(
            type: heartRateType,
            predicate: predicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { [weak self] _, samples, _, _, _ in
            self?.processSamples(samples)
        }

        query?.updateHandler = { [weak self] _, samples, _, _, _ in
            self?.processSamples(samples)
        }

        if let query = query {
            healthStore.execute(query)
            DispatchQueue.main.async { self.isMonitoring = true }
        }
    }

    // MARK: - 심박수 모니터링 중지
    func stopMonitoring() {
        if let query = query {
            healthStore.stop(query)
            self.query = nil
        }
        DispatchQueue.main.async {
            self.isMonitoring = false
        }
    }

    // MARK: - 샘플 처리
    private func processSamples(_ samples: [HKSample]?) {
        guard let samples = samples as? [HKQuantitySample], let latest = samples.last else { return }
        let bpm = latest.quantity.doubleValue(for: HKUnit(from: "count/min"))
        DispatchQueue.main.async {
            self.currentBPM = bpm
            self.sendBPMToPhone(bpm: bpm)
        }
    }

    // MARK: - iPhone으로 심박수 전송
    private func sendBPMToPhone(bpm: Double) {
        guard WCSession.default.isReachable else { return }
        let message: [String: Any] = ["heartBPM": bpm]
        WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }
}

// MARK: - WCSessionDelegate
extension HeartRateManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
