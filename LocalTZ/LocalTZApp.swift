import SwiftUI

@main
struct LocalTZApp: App {
    var body: some Scene {
        MenuBarExtra("tz") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
