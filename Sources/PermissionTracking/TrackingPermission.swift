import AppTrackingTransparency
import PermissionCore

/// Quyền App Tracking Transparency (ATT). Cần `NSUserTrackingUsageDescription`.
public struct TrackingPermission: Permission {
    public init() {}

    public var title: String { "Tracking" }

    public func status() async -> PermissionStatus {
        Self.map(ATTrackingManager.trackingAuthorizationStatus)
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = ATTrackingManager.trackingAuthorizationStatus
        guard current == .notDetermined else { return Self.map(current) }
        let result = await ATTrackingManager.requestTrackingAuthorization()
        return Self.map(result)
    }

    static func map(_ status: ATTrackingManager.AuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
