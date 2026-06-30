import Foundation

/// Trạng thái quyền đã chuẩn hoá cho mọi loại permission.
public enum PermissionStatus: String, Sendable, Equatable, CaseIterable {
    /// Người dùng chưa được hỏi.
    case notDetermined
    /// Đã cấp đầy đủ.
    case authorized
    /// Cấp giới hạn (Photos `limited`, Contacts `limited`...).
    case limited
    /// Cấp tạm thời/ngầm (Notification `provisional`).
    case provisional
    /// Người dùng từ chối.
    case denied
    /// Bị chặn bởi hệ thống (parental control, MDM...). Không thể tự đổi.
    case restricted

    /// Coi như đã có quyền dùng được (authorized / limited / provisional).
    public var isAuthorized: Bool {
        switch self {
        case .authorized, .limited, .provisional: return true
        case .notDetermined, .denied, .restricted: return false
        }
    }

    /// Có nên đẩy người dùng ra Settings không (denied/restricted).
    public var shouldOpenSettings: Bool {
        self == .denied || self == .restricted
    }
}
