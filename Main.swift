import SwiftUI

@main
struct Main: App {
    #if os(macOS)
    // To signal app termination on window close
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
