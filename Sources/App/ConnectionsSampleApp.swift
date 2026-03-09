import SwiftUI

@main
struct ConnectionsSampleApp: App {
    @State private var connectionService = ConnectionsService()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(connectionService)
                .task {
                    connectionService.startScanning()
                }
        }
    }
}
