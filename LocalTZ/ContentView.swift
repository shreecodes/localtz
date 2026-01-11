import SwiftUI
import AppKit

enum NowDisplayMode: CaseIterable {
    case objectId
    case epoch
    case isoLocal
}

struct ContentView: View {
    @State private var input = ""
    @State private var nowDisplayMode: NowDisplayMode = .objectId
    @State private var copiedId: String? = nil
    @State private var tick = false  // Triggers refresh every second

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var inputType: TimeParser.InputType {
        TimeParser.detect(input)
    }

    private var parsedTimestamp: Int64? {
        TimeParser.extractTimestamp(inputType)
    }

    private var showError: Bool {
        !input.isEmpty && parsedTimestamp == nil
    }

    private var currentNowDisplay: String {
        _ = tick  // Dependency to trigger refresh every second
        let timestamp = Int64(Date().timeIntervalSince1970)
        switch nowDisplayMode {
        case .objectId:
            return TimeParser.currentObjectId()
        case .epoch:
            return String(timestamp)
        case .isoLocal:
            return TimeParser.formatLocal(timestamp)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Current time row (click to cycle format)
            HStack {
                Button(action: { cycleNowDisplayMode() }) {
                    HStack {
                        Text("Now:")
                            .foregroundColor(.secondary)
                        Text(currentNowDisplay)
                            .font(.system(.body, design: .monospaced))
                    }
                }
                .buttonStyle(.plain)
                Spacer()
                copyButton(text: currentNowDisplay, id: "current")
            }

            Divider()

            // Input field
            TextField("Paste epoch or ObjectID...", text: $input)
                .textFieldStyle(.roundedBorder)
                .font(.system(.body, design: .monospaced))

            // Error message for invalid input
            if showError {
                Text("Invalid format")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // Results (shown when valid input)
            if let ts = parsedTimestamp {
                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    resultRow(label: "Local", value: TimeParser.formatLocal(ts), id: "local")
                    resultRow(label: "UTC", value: TimeParser.formatUTC(ts), id: "utc")
                }
            }

            Divider()

            // Quit button
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding()
        .frame(width: 360)
        .onReceive(timer) { _ in
            tick.toggle()
        }
    }

    private func cycleNowDisplayMode() {
        let allModes = NowDisplayMode.allCases
        let currentIndex = allModes.firstIndex(of: nowDisplayMode) ?? 0
        let nextIndex = (currentIndex + 1) % allModes.count
        nowDisplayMode = allModes[nextIndex]
    }

    @ViewBuilder
    private func resultRow(label: String, value: String, id: String) -> some View {
        HStack {
            Text("\(label):")
                .foregroundColor(.secondary)
                .frame(width: 40, alignment: .leading)
            Text(value)
                .font(.system(.body, design: .monospaced))
            Spacer()
            copyButton(text: value, id: id)
        }
    }

    @ViewBuilder
    private func copyButton(text: String, id: String) -> some View {
        Button(action: { copyToClipboard(text, id: id) }) {
            Image(systemName: copiedId == id ? "checkmark" : "doc.on.doc")
                .foregroundColor(copiedId == id ? .green : .secondary)
        }
        .buttonStyle(.borderless)
        .help("Copy to clipboard")
    }

    private func copyToClipboard(_ text: String, id: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        copiedId = id

        // Reset after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if copiedId == id {
                copiedId = nil
            }
        }
    }
}

#Preview {
    ContentView()
}
