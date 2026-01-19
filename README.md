# TishAudio

Virtual audio loopback driver for [Tish](https://github.com/beshkenadze/Tish) noise cancellation app.

**Forked from [BlackHole](https://github.com/ExistentialAudio/BlackHole)** by Existential Audio.

## Features

- 2 channel audio loopback
- Zero additional latency
- **Client tracking** - Detects which apps are using the virtual mic
- **Custom properties** - Expose "other apps doing I/O" state to companion app
- Supports 44.1kHz, 48kHz, 96kHz sample rates
- Universal binary (Intel + Apple Silicon)
- macOS 10.10+

## Custom Properties

TishAudio exposes custom CoreAudio properties for detecting when other apps use the virtual microphone:

| Property | Selector | Type | Description |
|----------|----------|------|-------------|
| `kTishDevicePropertyOtherClientsDoingIO` | `'toci'` | UInt32 | 1 if any app OTHER than Tish is doing I/O, 0 otherwise |
| `kTishDevicePropertyOtherClientsIOCount` | `'tocc'` | UInt32 | Count of non-Tish clients doing I/O |

### Usage in Swift

```swift
import CoreAudio

// Property selector (must match TishAudioTypes.h)
let kTishDevicePropertyOtherClientsDoingIO: AudioObjectPropertySelector = 0x746F6369 // 'toci'

// Find TishAudio device
func findTishAudioDevice() -> AudioDeviceID? {
    var propertyAddress = AudioObjectPropertyAddress(
        mSelector: kAudioHardwarePropertyDevices,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    var dataSize: UInt32 = 0
    AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, &dataSize)
    
    let deviceCount = Int(dataSize) / MemoryLayout<AudioDeviceID>.size
    var devices = [AudioDeviceID](repeating: 0, count: deviceCount)
    AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &propertyAddress, 0, nil, &dataSize, &devices)
    
    for device in devices {
        // Check device UID for "BlackHole"
        var uid: CFString?
        var uidSize = UInt32(MemoryLayout<CFString?>.size)
        var uidAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyDeviceUID,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        AudioObjectGetPropertyData(device, &uidAddress, 0, nil, &uidSize, &uid)
        if let uid = uid as String?, uid.contains("BlackHole") {
            return device
        }
    }
    return nil
}

// Listen for changes
func startListening(deviceID: AudioDeviceID) {
    var address = AudioObjectPropertyAddress(
        mSelector: kTishDevicePropertyOtherClientsDoingIO,
        mScope: kAudioObjectPropertyScopeGlobal,
        mElement: kAudioObjectPropertyElementMain
    )
    
    AudioObjectAddPropertyListenerBlock(deviceID, &address, DispatchQueue.main) { _, _ in
        var isOtherAppsRunning: UInt32 = 0
        var size = UInt32(MemoryLayout<UInt32>.size)
        AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &isOtherAppsRunning)
        
        if isOtherAppsRunning == 1 {
            print("Other apps started using TishAudio")
            // Enable noise cancellation
        } else {
            print("Other apps stopped using TishAudio")
            // Disable noise cancellation
        }
    }
}
```

## Build

```bash
xcodebuild -scheme BlackHole -configuration Release build
```

## Install

```bash
# Copy driver to system location
sudo cp -R ~/Library/Developer/Xcode/DerivedData/BlackHole-*/Build/Products/Release/BlackHole.driver /Library/Audio/Plug-Ins/HAL/TishAudio.driver

# Restart CoreAudio
sudo killall -9 coreaudiod
```

## Uninstall

```bash
sudo rm -rf /Library/Audio/Plug-Ins/HAL/TishAudio.driver
sudo killall -9 coreaudiod
```

## Architecture

```
┌─────────────────┐     ┌──────────────────────────────┐     ┌─────────────────┐
│  Zoom/QuickTime │────▶│  TishAudio Driver            │────▶│   Tish App      │
│   (client app)  │     │  (AudioServerPlugIn)         │     │   (companion)   │
└─────────────────┘     │                              │     └─────────────────┘
                        │  AddDeviceClient(info)       │            ▲
                        │  RemoveDeviceClient(info)    │            │
                        │  StartIO(clientID)           │     Custom Properties
                        │  StopIO(clientID)            │     via CoreAudio API
                        │                              │            │
                        │  Tracks: PID, BundleID, IO   │────────────┘
                        └──────────────────────────────┘
```

## License

GPL-3.0 (inherited from BlackHole)

## Credits

- [BlackHole](https://github.com/ExistentialAudio/BlackHole) by Existential Audio
- [BackgroundMusic](https://github.com/kyleneideck/BackgroundMusic) for client tracking reference
- [Tish](https://github.com/beshkenadze/Tish) noise cancellation app
