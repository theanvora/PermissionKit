import Photos
import PermissionCore

/// Quyền Photo Library. Cần `NSPhotoLibraryUsageDescription`
/// (và `NSPhotoLibraryAddUsageDescription` nếu chỉ ghi).
public struct PhotosPermission: Permission {
    /// Mức truy cập muốn xin.
    public enum Access: Sendable {
        case readWrite
        case addOnly
    }

    private let access: Access

    public init(access: Access = .readWrite) {
        self.access = access
    }

    public var title: String { "Photos" }

    private var level: PHAccessLevel {
        access == .addOnly ? .addOnly : .readWrite
    }

    public func status() async -> PermissionStatus {
        Self.map(PHPhotoLibrary.authorizationStatus(for: level))
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = PHPhotoLibrary.authorizationStatus(for: level)
        guard current == .notDetermined else { return Self.map(current) }
        let result = await PHPhotoLibrary.requestAuthorization(for: level)
        return Self.map(result)
    }

    static func map(_ status: PHAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .limited:       return .limited
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
