import ConnectionsSDK
import ConnectionsSDKApple
import Foundation
import Observation

@Observable
@MainActor
final class ConnectionsService {

    // MARK: - Scanning / device list state
    var discoveredDevices: [DiscoveredDevice] = []
    var isScanning: Bool = false

    // MARK: - Connection state
    var connectedDevice: DiscoveredDevice?

    // MARK: - Rowing metrics (non-nil when connected and data is flowing)
    var strokeRate: Int?
    var powerWatts: Int?
    var splitSeconds: Double?
    var distanceMeters: Double?

    // MARK: - Error
    var errorMessage: String?

    // MARK: - Private
    private let module: ConnectionsModule
    private var scanTask: Task<Void, Never>?
    private var driveTask: Task<Void, Never>?
    private var distanceTask: Task<Void, Never>?

    init() {
        module = AppleConnectionsModule { builder in
            builder.add(capability: AppleRowingCapabilityKt.create())
            builder.rememberConnections(enabled: true)
            builder.appleLogging()
            #if DEBUG
            builder.includeFakes()
            #endif
        }
    }

    // MARK: - Scanning

    func startScanning() {
        guard scanTask == nil else { return }
        isScanning = true
        scanTask = Task { [weak self] in
            guard let self else { return }
            for await devices in module.deviceListProvider().devices() {
                await MainActor.run {
                    self.discoveredDevices = devices
                }
            }
        }
    }

    func stopScanning() {
        scanTask?.cancel()
        scanTask = nil
        isScanning = false
    }

    // MARK: - Connection

    func connect(to device: DiscoveredDevice) async {
        errorMessage = nil
        do {
            try await module.connectionManager.connect(device: device.device)
            connectedDevice = device
            startMetricListeners()
        } catch {
            errorMessage = "Connection failed: \(error.localizedDescription)"
        }
    }

    func disconnect() async {
        guard let device = connectedDevice else { return }
        stopMetricListeners()
        connectedDevice = nil
        strokeRate = nil
        powerWatts = nil
        splitSeconds = nil
        distanceMeters = nil
        do {
            try await module.connectionManager.forget(deviceId: device.device.id)
        } catch {
            errorMessage = "Disconnect failed: \(error.localizedDescription)"
        }
    }

    // MARK: - Metrics

    private func startMetricListeners() {
        let rowerData = module.rowerDataSource()

        driveTask = Task { [weak self] in
            guard let self else { return }
            for await drive in rowerData.drive() {
                await MainActor.run {
                    if let spm = drive.strokeRate?.strokesPerMinute {
                        self.strokeRate = Int(spm)
                    }
                    self.powerWatts = Int(drive.power.watts)
                    if let ns = drive.pace?.split500m.nanoseconds {
                        self.splitSeconds = Double(ns) / 1_000_000_000.0
                    }
                }
            }
        }

        distanceTask = Task { [weak self] in
            guard let self else { return }
            for await distance in rowerData.distanceUpdates() {
                await MainActor.run {
                    let delta = Double(distance.inNanometers) / 1_000_000_000.0
                    self.distanceMeters = (self.distanceMeters ?? 0) + delta
                }
            }
        }
    }

    private func stopMetricListeners() {
        driveTask?.cancel()
        driveTask = nil
        distanceTask?.cancel()
        distanceTask = nil
    }
}
