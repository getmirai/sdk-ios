import SwiftUI

@main
struct PlaygroundApp: App {
    @StateObject var model: PlaygroundModel

    init() {
        let initialModel = PlaygroundModel()
        _model = StateObject(wrappedValue: initialModel)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(self.model)
    }
}
