import Contacts
import PermissionCore

/// Quyền Contacts. Cần `NSContactsUsageDescription` trong Info.plist.
public struct ContactsPermission: Permission {
    public init() {}

    public var title: String { "Contacts" }

    public func status() async -> PermissionStatus {
        Self.map(CNContactStore.authorizationStatus(for: .contacts))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = CNContactStore.authorizationStatus(for: .contacts)
        guard current == .notDetermined else { return Self.map(current) }
        let granted = (try? await CNContactStore().requestAccess(for: .contacts)) ?? false
        return granted ? .authorized : .denied
    }

    static func map(_ status: CNAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:
            // iOS 18+ thêm `.limited`; map qua limited nếu có.
            if #available(iOS 18.0, *), status == .limited {
                return .limited
            }
            return .denied
        }
    }
}
