import Foundation

struct TimeParser {
    enum InputType: Equatable {
        case epochSeconds(Int64)
        case epochMilliseconds(Int64)
        case mongoObjectId(String)
        case invalid
    }

    /// Detect the type of timestamp input from a string
    static func detect(_ input: String) -> InputType {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            return .invalid
        }

        // Check for MongoDB ObjectID (24 hex chars)
        if trimmed.count == 24,
           trimmed.allSatisfy({ $0.isHexDigit }) {
            return .mongoObjectId(trimmed)
        }

        // Check for numeric epoch
        if let value = Int64(trimmed) {
            if trimmed.count == 13 {
                return .epochMilliseconds(value)
            } else if trimmed.count >= 9 && trimmed.count <= 10 {
                return .epochSeconds(value)
            }
        }

        return .invalid
    }

    /// Extract Unix timestamp (in seconds) from the detected input type
    static func extractTimestamp(_ inputType: InputType) -> Int64? {
        switch inputType {
        case .epochSeconds(let ts):
            return ts
        case .epochMilliseconds(let ts):
            return ts / 1000
        case .mongoObjectId(let id):
            // First 8 hex chars = 4 bytes = timestamp in seconds
            let hex = String(id.prefix(8))
            return Int64(hex, radix: 16)
        case .invalid:
            return nil
        }
    }

    /// Generate a MongoDB ObjectID for the current timestamp with zeros for the random portion
    static func currentObjectId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let hex = String(timestamp, radix: 16, uppercase: false)
        let paddedHex = String(repeating: "0", count: max(0, 8 - hex.count)) + hex
        return paddedHex + "0000000000000000"
    }

    /// Format a Unix timestamp to ISO 8601 in the local timezone
    static func formatLocal(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = .current
        return formatter.string(from: date)
    }

    /// Format a Unix timestamp to ISO 8601 in UTC
    static func formatUTC(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: date)
    }
}
