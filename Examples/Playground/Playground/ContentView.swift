import SwiftUI
import Mirai

struct ContentView: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel

    var contentView: some View {
        var modelsLoaded = true
        for model in playgroundModel.modelsService.models {
            let modelFiles = MiraiEngine.shared.storage.localFiles(for: model)
            modelsLoaded = modelsLoaded && (modelFiles != nil)
        }

        return ZStack(alignment: .center) {
            if modelsLoaded {
                PlaygroundScreen()
            } else {
                ModelsScreen()
            }
        }
    }

    var body: some View {
        ZStack(alignment: .center) {
            Colors.background
                .ignoresSafeArea(.all)
            contentView
        }
    }
}
