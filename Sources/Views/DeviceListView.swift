import ConnectionsSDK
import SwiftUI

struct DeviceListView: View {
    @Environment(ConnectionsService.self) private var service

    var body: some View {
        Group {
            if service.discoveredDevices.isEmpty {
                VStack(spacing: 12) {
                    ProgressView()
                    Text("Scanning for rowing machines…")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(service.discoveredDevices, id: \.device.id.value) { device in
                    DeviceRowView(device: device)
                }
            }
        }
        .navigationTitle("Devices")
        .alert("Error", isPresented: Binding(
            get: { service.errorMessage != nil },
            set: { if !$0 { service.errorMessage = nil } }
        )) {
            Button("OK") { service.errorMessage = nil }
        } message: {
            Text(service.errorMessage ?? "")
        }
    }
}
