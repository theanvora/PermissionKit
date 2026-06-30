import EventKit
import PermissionCore

/// Reminders access. Declare `NSRemindersUsageDescription`
/// (iOS 17+ uses `NSRemindersFullAccessUsageDescription`).
public struct RemindersPermission: Permission {
    public init() {}

    public var title: String { "Reminders" }

    public func status() async -> PermissionStatus {
        Self.map(EKEventStore.authorizationStatus(for: .reminder))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = EKEventStore.authorizationStatus(for: .reminder)
        guard current == .notDetermined else { return Self.map(current) }

        let store = EKEventStore()
        do {
            let granted: Bool
            if #available(iOS 17.0, *) {
                granted = try await store.requestFullAccessToReminders()
            } else {
                granted = try await store.requestAccess(to: .reminder)
            }
            return granted ? .authorized : .denied
        } catch {
            return .denied
        }
    }

    static func map(_ status: EKAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .restricted:    return .restricted
        case .denied:        return .denied
        case .authorized:    return .authorized   // same raw value as .fullAccess on iOS 17+
        @unknown default:
            if #available(iOS 17.0, *), status == .writeOnly { return .limited }
            return .denied
        }
    }
}
