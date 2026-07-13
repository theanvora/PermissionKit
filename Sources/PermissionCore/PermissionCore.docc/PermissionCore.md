# ``PermissionCore``

The shared foundation for PermissionKit: a uniform ``Permission`` protocol, status
model, observable state, and a reusable request button — with one small domain
module per system permission built on top.

## Overview

Every domain (camera, photos, location, contacts, notifications, …) ships as its own
tiny module conforming to ``Permission``, so an app links only what it uses. Drive UI
with ``PermissionState`` and ``PermissionButton``, and deep-link to Settings via
``PermissionSettings``.

```swift
let state = PermissionState(CameraPermission())   // from the PermissionCamera module
PermissionButton(state: state) { Text("Enable Camera") }
```

### Domain modules

Add the module for each permission you need: `PermissionCamera`, `PermissionPhotos`,
`PermissionMicrophone`, `PermissionLocation`, `PermissionContacts`,
`PermissionCalendar`, `PermissionReminders`, `PermissionNotification`,
`PermissionMotion`, `PermissionHealth`, `PermissionSpeech`, `PermissionMusic`,
`PermissionBluetooth`, `PermissionTracking`, `PermissionSiri`, `PermissionBiometric`.
Each exposes a single small type conforming to ``Permission``.

## Topics

- ``Permission``
- ``PermissionStatus``
- ``PermissionState``
- ``PermissionButton``
- ``PermissionSettings``
