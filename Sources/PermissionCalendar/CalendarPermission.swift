import EventKit
import PermissionCore

/// Calendar (events) access. Declare `NSCalendarsUsageDescription`
/// (and `NSCalendarsWriteOnlyAccessUsageDescription` for `.writeOnly`).
public struct CalendarPermission: Permission {
    public enum Access: Sendable {
        case full
        case writeOnly
    }

    private let access: Access

    public init(access: Access = .full) {
        self.access = access
    }

    public var title: String { "Calendar" }

    public func status() async -> PermissionStatus {
        Self.map(EKEventStore.authorizationStatus(for: .event))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = EKEventStore.authorizationStatus(for: .event)
        guard current == .notDetermined else { return Self.map(current) }

        let store = EKEventStore()
        do {
            if #available(iOS 17.0, *) {
                let granted = try await {
                    switch access {
                    case .full:      return try await store.requestFullAccessToEvents()
                    case .writeOnly: return try await store.requestWriteOnlyAccessToEvents()
                    }
                }()
                return granted ? (access == .writeOnly ? .limited : .authorized) : .denied
            } else {
                let granted = try await store.requestAccess(to: .event)
                return granted ? .authorized : .denied
            }
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
