import LocalAuthentication
import PermissionCore

/// Face ID / Touch ID. Declare `NSFaceIDUsageDescription`.
///
/// Biometrics aren't a classic "grant once" permission — `request()` actually
/// runs an authentication challenge and reports whether it succeeded.
public struct BiometricPermission: Permission {
    public init() {}

    public var title: String { "Face ID / Touch ID" }

    public func status() async -> PermissionStatus {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return .notDetermined   // available and ready to challenge
        }
        guard let code = error.map({ LAError.Code(rawValue: $0.code) }) else { return .denied }
        switch code {
        case .biometryNotAvailable: return .restricted
        case .biometryNotEnrolled:  return .notDetermined
        case .biometryLockout:      return .denied
        default:                    return .denied
        }
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .denied
        }
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: title
            )
            return success ? .authorized : .denied
        } catch {
            return .denied
        }
    }
}
