#if canImport(SwiftUI)
import SwiftUI

/// Wrapper observable cho SwiftUI: giữ trạng thái 1 quyền và expose request/refresh.
///
/// ```swift
/// @StateObject private var camera = PermissionState(CameraPermission())
///
/// var body: some View {
///     Button("Bật camera") { Task { await camera.request() } }
///         .task { await camera.refresh() }
/// }
/// ```
@MainActor
public final class PermissionState: ObservableObject {
    @Published public private(set) var status: PermissionStatus = .notDetermined

    private let permission: Permission

    public init(_ permission: Permission) {
        self.permission = permission
    }

    public var isAuthorized: Bool { status.isAuthorized }

    /// Đọc lại trạng thái (không bật popup).
    public func refresh() async {
        status = await permission.status()
    }

    /// Xin quyền và cập nhật `status`.
    @discardableResult
    public func request() async -> PermissionStatus {
        status = await permission.request()
        return status
    }

    /// Nếu chưa hỏi thì xin; nếu bị từ chối thì mở Settings.
    public func requestOrOpenSettings() async {
        let result = await request()
        if result.shouldOpenSettings {
            PermissionSettings.open()
        }
    }
}
#endif
