import ProjectDescription

let devTeam = Environment.developmentTeam.getString(default: "Q8H6GWJ658")

let project = Project(
    name: "TishAudio",
    organizationName: "Beshkenadze",
    targets: [
        .target(
            name: "TishAudio",
            destinations: .macOS,
            product: .bundle,
            bundleId: "app.beshkenadze.driver.TishAudio",
            deploymentTargets: .macOS("10.13"),
            infoPlist: .extendingDefault(with: [
                "CFBundleDevelopmentRegion": "English",
                "CFBundleIconFile": "TishAudio.icns",
                "CFBundleName": "TishAudio",
                "CFBundlePackageType": "BNDL",
                "CFBundleShortVersionString": "1.0.0",
                "CFBundleVersion": "1",
                "CFPlugInFactories": [
                    "e395c745-4eea-4d94-bb92-46224221047c": "TishAudio_Create"
                ],
                "CFPlugInTypes": [
                    "443ABAB8-E7B3-491A-B985-BEB9187030DB": ["e395c745-4eea-4d94-bb92-46224221047c"]
                ],
                "NSHumanReadableCopyright": "Copyright 2026 Aleksandr Beshkenadze. Based on BlackHole by Existential Audio Inc."
            ]),
            sources: ["Sources/TishAudio/**"],
            resources: ["Sources/TishAudio/TishAudio.icns"],
            settings: .settings(
                base: [
                    "WRAPPER_EXTENSION": "driver",
                    "MACOSX_DEPLOYMENT_TARGET": "10.13",
                    "CODE_SIGN_STYLE": "Automatic",
                    "DEVELOPMENT_TEAM": "\(devTeam)",
                    "CODE_SIGN_IDENTITY": "Apple Development",
                    "GCC_C_LANGUAGE_STANDARD": "gnu11",
                    "CLANG_ENABLE_MODULES": "YES",
                    "ENABLE_HARDENED_RUNTIME": "YES"
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        )
    ],
    schemes: [
        .scheme(
            name: "TishAudio",
            buildAction: .buildAction(targets: ["TishAudio"])
        )
    ]
)
