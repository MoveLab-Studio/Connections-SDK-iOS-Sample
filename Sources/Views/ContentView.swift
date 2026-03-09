import SwiftUI

struct ContentView: View {
    @Environment(ConnectionsService.self) private var service

    var body: some View {
        NavigationStack {
            if service.connectedDevice != nil {
                MetricsView()
            } else {
                DeviceListView()
            }
        }
    }
}
