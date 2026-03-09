# Connections SDK iOS Sample

Minimal iOS sample app demonstrating the Connections SDK for rowing machine integration.

## What it shows

- Module initialization with `AppleConnectionsModule`
- Device scanning via `DeviceListProvider`
- Connecting to a rowing machine via `ConnectionManager`
- Live metrics via `RowerDataSource`: stroke rate, split, power, distance
- Fake device support for running without hardware (debug builds)

## Requirements

- Xcode 16+
- iOS 18+ device or simulator
- GitHub Personal Access Token with read access to MoveLab-Studio repos

## Getting Started (Tuist)

1. Clone this repo
2. Copy `.env.example` to `.env` and fill in your `GITHUB_ACCESS_TOKEN`
3. Run `make generate`
4. Run `make open`
5. Build and run the `ConnectionsSDKSample` scheme

In debug builds a simulated ("Fake") rowing machine appears automatically in the device list — no hardware required.

## Authentication

The SDK dependencies are hosted in private GitHub repos under `MoveLab-Studio`. You need a GitHub Personal Access Token (classic or fine-grained) with at least **read access to repository contents**.

### How it works with Tuist

Tuist evaluates `Package.swift` inside a sandbox that strips environment variables, so the token cannot be read there. Instead, `make generate` uses **git URL rewriting** to inject credentials transparently:

```
git config --global url."https://oauth2:<TOKEN>@github.com/MoveLab-Studio/".insteadOf \
                        "https://github.com/MoveLab-Studio/"
```

`Package.swift` declares plain `https://github.com/MoveLab-Studio/…` URLs. When Tuist asks git to fetch those URLs, git silently rewrites them to include the token. The Makefile cleans up the global git config entry after the run.

### Without Tuist (plain Swift Package Manager)

If you add the SDK directly to an Xcode project or a `Package.swift` without Tuist, git URL rewriting still works and is the recommended approach. Run this once before opening Xcode or running `swift package resolve`:

```sh
git config --global url."https://oauth2:<TOKEN>@github.com/MoveLab-Studio/".insteadOf \
                        "https://github.com/MoveLab-Studio/"
```

Alternatively you can store credentials in the macOS keychain via Xcode's **Settings → Accounts** — add your GitHub account and Xcode will authenticate automatically when SPM resolves packages.

A third option is to use token-embedded URLs directly in your `Package.swift`:

```swift
.package(url: "https://oauth2:<TOKEN>@github.com/MoveLab-Studio/Connections-SDK-Apple-Distribution.git", ...)
```

This works but risks accidentally committing the token, so prefer the git config or keychain approaches.

## Key Files

| File | Purpose |
|---|---|
| `Sources/Services/ConnectionsService.swift` | Core SDK integration |
| `Sources/Views/DeviceListView.swift` | Device scanning UI |
| `Sources/Views/MetricsView.swift` | Live metrics display |
| `Tuist/Package.swift` | SDK dependency declaration |
| `Project.swift` | Tuist target configuration |
