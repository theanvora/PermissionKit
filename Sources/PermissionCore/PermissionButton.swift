//
//  PermissionButton.swift
//  PermissionKit
//
//  Created by AnhPT on 02/07/2026.
//

#if canImport(SwiftUI)
import SwiftUI

/// A drop-in SwiftUI button that handles the whole flow: tap to request, and
/// route to Settings automatically once access has been refused.
///
/// ```swift
/// PermissionButton(CameraPermission()) { status in
///     Label("Camera", systemImage: status.isAuthorized ? "checkmark" : "camera")
/// }
/// ```
public struct PermissionButton<Label: View>: View {
    @State private var state: PermissionState
    private let label: (PermissionStatus) -> Label
    private let onChange: ((PermissionStatus) -> Void)?

    public init(
        _ permission: Permission,
        onChange: ((PermissionStatus) -> Void)? = nil,
        @ViewBuilder label: @escaping (PermissionStatus) -> Label
    ) {
        _state = State(wrappedValue: PermissionState(permission))
        self.label = label
        self.onChange = onChange
    }

    public var body: some View {
        Button {
            Task {
                await state.requestOrOpenSettings()
                onChange?(state.status)
            }
        } label: {
            label(state.status)
        }
        .task { await state.refresh() }
    }
}
#endif
