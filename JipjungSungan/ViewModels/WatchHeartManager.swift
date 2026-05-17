import Foundation
import WatchConnectivity

// 집중의 순간 iPhone - Watch로부터 심박수 수신 매니저
// WatchConnectivity로 Watch에서 보낸 heartBPM 수신
class WatchHeartManager: NSObject, ObservableObject {
    static let shared = WatchHeartManager()

    @Published var receivedBPM: Double? = nil
    @Published var isWatchConnected: Bool = false

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }
}

extension WatchHeartManager: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchConnected = session.isPaired && session.isWatchAppInstalled
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    // Watch에서 메시지 수신
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let bpm = message["heartBPM"] as? Double {
            DispatchQueue.main.async {
                self.receivedBPM = bpm
            }
        }
    }
}
