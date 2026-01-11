# LocalTZ

A macOS menu bar utility for converting Unix epochs and MongoDB ObjectIDs to human-readable timestamps.

![macOS](https://img.shields.io/badge/macOS-13.0%2B-blue)

## Features

- **Live current timestamp** — Click to cycle between ObjectID, epoch, and ISO formats
- **Auto-detect input** — Paste any of these formats:
  - Unix epoch (seconds): `1704067200`
  - Unix epoch (milliseconds): `1704067200000`
  - MongoDB ObjectID: `507f1f77bcf86cd799439011`
- **Instant conversion** — See local and UTC times in ISO 8601 format
- **One-click copy** — Copy any value to clipboard

## Install

```bash
brew tap shreecodes/localtz
brew install --cask localtz
```

Or download directly from [Releases](https://github.com/shreecodes/localtz/releases).

## Usage

1. Click "tz" in the menu bar
2. Paste an epoch or ObjectID into the input field
3. View converted times in local and UTC
4. Click the copy button next to any value

Click the "Now" row to cycle through display formats:
- ObjectID: `678112a00000000000000000`
- Epoch: `1736524960`
- ISO: `2024-01-10T14:30:00-05:00`

## Building from Source

Requires Xcode 15+ and macOS 13+.

```bash
git clone https://github.com/shreecodes/localtz.git
cd localtz
open LocalTZ.xcodeproj
```

Build and run with Cmd+R.

## License

MIT
