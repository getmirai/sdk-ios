import SwiftUI
import Mirai

struct ModelsScreen: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel

    var status: ModelsStorageLoadingStatus? {
        return playgroundModel.modelsService.status
    }

    var progress: Double {
        return status?.overallProgress ?? 0.0
    }

    var progressView: some View {
        let width = UIScreen.main.bounds.width * 0.6
        let height = 4.0
        let cornerRadius = height / 2.0

        return ZStack(alignment: .leading) {
            Rectangle()
                .foregroundColor(.clear)
                .background(Colors.card)
            Rectangle()
                .frame(width: width * progress)
                .foregroundColor(.clear)
                .background(Colors.primary)
        }
        .frame(width: width, height: height)
        .cornerRadius(cornerRadius)
    }

    var body: some View {
        let padding = 32.0
        return VStack(alignment: .center, spacing: 0.0) {
            Spacer(minLength: 0.0)
            progressView
            Spacer(minLength: 0.0)
                .frame(height: 24.0)
            Text(Strings.installing.uppercased())
                .font(Fonts.mono22Semibold)
                .foregroundStyle(Colors.primary)
            if let status {
                Spacer(minLength: 0.0)
                    .frame(height: 8.0)
                Text(status.identifier)
                    .font(Fonts.mono12Regular)
                    .foregroundStyle(Colors.secondary)
                    .multilineTextAlignment(.center)
            }
            Spacer(minLength: 0.0)
        }
        .padding(padding)
        .onAppear {
            Task {
                try await playgroundModel.modelsService.download()
            }
        }
    }
}
