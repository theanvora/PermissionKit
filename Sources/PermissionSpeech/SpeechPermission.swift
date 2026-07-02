//
//  SpeechPermission.swift
//  PermissionKit
//
//  Created by Anvora on 02/07/2026.
//

import Speech
import PermissionCore

/// Speech-to-text recognition. Declare `NSSpeechRecognitionUsageDescription`
/// (pair it with microphone access for live transcription).
public struct SpeechPermission: Permission {
    public init() {}

    public var title: String { "Speech Recognition" }

    public func status() async -> PermissionStatus {
        Self.map(SFSpeechRecognizer.authorizationStatus())
    }

    @discardableResult
    public func request() async -> PermissionStatus {
        let current = SFSpeechRecognizer.authorizationStatus()
        guard current == .notDetermined else { return Self.map(current) }
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: Self.map(status))
            }
        }
    }

    static func map(_ status: SFSpeechRecognizerAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .notDetermined: return .notDetermined
        case .authorized:    return .authorized
        case .denied:        return .denied
        case .restricted:    return .restricted
        @unknown default:    return .denied
        }
    }
}
