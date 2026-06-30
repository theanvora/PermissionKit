import Intents
import PermissionCore

/// SiriKit access. Declare `NSSiriUsageDescription`.
public struct SiriPermission: Permission {
    public init() {}

    public var title: String { "Siri" }

    public func status() async -> PermissionStatus {
        Self.map(INPreferences.siriAuthorizationStatus())
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = INPreferences.siriAuthorizationStatus()
        guard current == .notDetermined else { return Self.map(current) }
        return await withCheckedContinuation { continuation in
            INPreferences.requestSiriAuthorization { status in
                continuation.resume(returning: Self.map(status))
            }
        }
    }

    static func map(_ status: INSiriAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
