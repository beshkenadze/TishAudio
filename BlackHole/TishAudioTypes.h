/*
 *  TishAudioTypes.h
 *  TishAudio
 *
 *  Custom property constants for TishAudio driver.
 *  Include this header in the Tish companion app to use these properties.
 */

#ifndef TishAudioTypes_h
#define TishAudioTypes_h

#include <CoreAudio/AudioHardware.h>

//==================================================================================================
#pragma mark TishAudio Custom Property Selectors
//==================================================================================================

enum {
    // UInt32: 1 if any client OTHER than Tish app is doing I/O on the device, 0 otherwise.
    // Listen to this property to detect when conferencing apps start/stop using the virtual mic.
    // Usage:
    //   AudioObjectPropertyAddress address = {
    //       kTishDevicePropertyOtherClientsDoingIO,
    //       kAudioObjectPropertyScopeGlobal,
    //       kAudioObjectPropertyElementMain
    //   };
    //   AudioObjectAddPropertyListenerBlock(deviceID, &address, queue, handler);
    kTishDevicePropertyOtherClientsDoingIO = 'toci',
    
    // UInt32: Count of clients currently doing I/O (excluding Tish app).
    kTishDevicePropertyOtherClientsIOCount = 'tocc',
};

//==================================================================================================
#pragma mark TishAudio Bundle IDs
//==================================================================================================

// Bundle ID of the TishAudio driver
#define kTishAudioDriverBundleID "audio.existential.BlackHole2ch"

// Bundle ID of the Tish companion app (used to exclude from "other clients" detection)
#define kTishAppBundleID "com.beshkenadze.Tish"

// Device UID for TishAudio virtual device
#define kTishAudioDeviceUID "BlackHole2ch_UID"

#endif /* TishAudioTypes_h */
