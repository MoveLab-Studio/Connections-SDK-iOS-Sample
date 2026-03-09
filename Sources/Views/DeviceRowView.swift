import ConnectionsSDKApple
import SwiftUI

struct DeviceRowView: View {
    let device: DiscoveredDevice
    @Environment(ConnectionsService.self) private var service

    private var statusLabel: String {
        switch device.connectionStatus {
        case .disconnected: return "Tap to connect"
        case .connecting:   return "Connecting…"
        case .connected:    return "Connected"
        case .failed:       return "Failed — tap to retry"
        }
    }

    private var isConnecting: Bool {
        if case .connecting = device.connectionStatus { return true }
        return false
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(device.device.name ?? "Unknown Device")
                    .font(.headline)
                Text(statusLabel)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if isConnecting {
                ProgressView()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            Task {
                await service.connect(to: device)
            }
        }
        .disabled(isConnecting)
    }
}
