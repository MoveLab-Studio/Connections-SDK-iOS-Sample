import SwiftUI

struct MetricsView: View {
    @Environment(ConnectionsService.self) private var service

    private var deviceName: String {
        service.connectedDevice?.device.name ?? "Rowing Machine"
    }

    private var formattedSplit: String {
        guard let s = service.splitSeconds, s > 0 else { return "—" }
        let minutes = Int(s) / 60
        let seconds = Int(s) % 60
        return String(format: "%d:%02d /500m", minutes, seconds)
    }

    private var formattedDistance: String {
        guard let d = service.distanceMeters else { return "—" }
        return String(format: "%.0f m", d)
    }

    var body: some View {
        VStack(spacing: 32) {
            MetricTileView(
                title: "Stroke Rate",
                value: service.strokeRate.map { "\($0)" } ?? "—",
                unit: "spm"
            )
            MetricTileView(
                title: "Split",
                value: formattedSplit,
                unit: ""
            )
            MetricTileView(
                title: "Power",
                value: service.powerWatts.map { "\($0)" } ?? "—",
                unit: "W"
            )
            MetricTileView(
                title: "Distance",
                value: formattedDistance,
                unit: ""
            )

            Button(role: .destructive) {
                Task { await service.disconnect() }
            } label: {
                Text("Disconnect")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)
        }
        .padding()
        .navigationTitle(deviceName)
        .navigationBarBackButtonHidden(true)
    }
}

private struct MetricTileView: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 52, weight: .bold, design: .monospaced))
                if !unit.isEmpty {
                    Text(unit)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
