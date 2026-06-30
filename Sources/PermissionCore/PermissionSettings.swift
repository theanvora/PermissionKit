#if canImport(UIKit)
import UIKit

/// Mở trang Settings của app (khi quyền bị denied/restricted).
public enum PermissionSettings {
    @MainActor
    public static func open() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
#endif
