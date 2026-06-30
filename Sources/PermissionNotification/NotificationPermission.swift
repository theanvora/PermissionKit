import UserNotifications
import PermissionCore

/// Local and remote notification authorization.
public struct NotificationPermission: Permission {
    private let options: UNAuthorizationOptions

    public init(options: UNAuthorizationOptions = [.alert, .sound, .badge]) {
        self.options = options
    }

    public var title: String { "Notifications" }

    public func status() async -> PermissionStatus {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        return Self.map(settings.authorizationStatus)
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = await status()
        guard current == .notDetermined else { return current }
        _ = try? await UNUserNotificationCenter.current().requestAuthorization(options: options)
        return await status()
    }

    static func map(_ status: UNAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .provisional:   return .provisional
        case .ephemeral:     return .authorized
        case .denied:        return .denied
        @unknown default:    return .denied
        }
    }
}
