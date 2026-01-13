# TishAudio

Virtual audio loopback driver for [Tish](https://github.com/AkiKurisu/Tish) noise cancellation app.

**Forked from [BlackHole](https://github.com/ExistentialAudio/BlackHole)** by Existential Audio.

## Features

- 2 channel audio loopback
- Zero additional latency
- Supports 44.1kHz, 48kHz, 96kHz sample rates
- Universal binary (Intel + Apple Silicon)
- macOS 10.10+

## Build

```bash
./Scripts/build_tishaudio.sh
```

## Install

```bash
sudo cp -R build/Release/TishAudio.driver /Library/Audio/Plug-Ins/HAL/
sudo killall -9 coreaudiod
```

## Uninstall

```bash
sudo rm -rf /Library/Audio/Plug-Ins/HAL/TishAudio.driver
sudo killall -9 coreaudiod
```

## License

GPL-3.0 (inherited from BlackHole)

## Credits

- [BlackHole](https://github.com/ExistentialAudio/BlackHole) by Existential Audio
- [Tish](https://github.com/AkiKurisu/Tish) noise cancellation app
