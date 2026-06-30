#if canImport(UIKit)
import UIKit

/// Jumps straight to this app's page in the system Settings — the fallback when
/// a permission is already denied or restricted.
public enum PermissionSettings {
    @MainActor
    public static func open() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
#endif
