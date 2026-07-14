//
//  PrePermissionView.swift
//  PermissionKit
//
//  Created by AnhPT on 14/07/2026.
//

#if canImport(SwiftUI)
import SwiftUI

/// A pre-permission "priming" screen: explain *why* access is needed **before**
/// the one-shot system prompt, so the user is far more likely to allow it (and
/// you don't burn the single OS dialog on an unexplained ask).
///
/// "Allow" triggers the real request (routing to Settings if already denied);
/// "Not now" simply dismisses via `onSkip`.
///
/// ```swift
/// PrePermissionView(CameraPermission(),
///                   systemImage: "camera.fill",
///                   headline: "Scan documents",
///                   message: "We use the camera only to capture your documents.") { status in
///     if status.isAuthorized { proceed() }
/// } onSkip: { dismiss() }
/// ```
public struct PrePermissionView: View {
    @State private var state: PermissionState
    private let systemImage: String
    private let headline: String
    private let message: String
    private let allowTitle: String
    private let skipTitle: String
    private let onDecision: ((PermissionStatus) -> Void)?
    private let onSkip: (() -> Void)?

    public init(
        _ permission: Permission,
        systemImage: String,
        headline: String,
        message: String,
        allowTitle: String = "Allow",
        skipTitle: String = "Not now",
        onDecision: ((PermissionStatus) -> Void)? = nil,
        onSkip: (() -> Void)? = nil
    ) {
        _state = State(wrappedValue: PermissionState(permission))
        self.systemImage = systemImage
        self.headline = headline
        self.message = message
        self.allowTitle = allowTitle
        self.skipTitle = skipTitle
        self.onDecision = onDecision
        self.onSkip = onSkip
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 56))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
            Text(headline)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(allowTitle) {
                Task {
                    await state.requestOrOpenSettings()
                    onDecision?(state.status)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top, 8)

            Button(skipTitle) { onSkip?() }
                .foregroundStyle(.secondary)
        }
        .padding(28)
        .task { await state.refresh() }
    }
}
#endif
