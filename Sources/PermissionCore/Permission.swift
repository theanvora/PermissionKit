import Foundation

/// Giao thức chung cho mọi quyền. Mỗi quyền nằm ở 1 target riêng,
/// chỉ import system framework tương ứng (Camera → AVFoundation, ...).
public protocol Permission: Sendable {
    /// Tên hiển thị (dùng cho UI/log).
    var title: String { get }

    /// Đọc trạng thái hiện tại, KHÔNG bật popup hệ thống.
    func status() async -> PermissionStatus

    /// Xin quyền. Nếu đã quyết định rồi thì trả về trạng thái hiện tại,
    /// không hiện lại popup.
    @discardableResult
    func request() async -> PermissionStatus
}
