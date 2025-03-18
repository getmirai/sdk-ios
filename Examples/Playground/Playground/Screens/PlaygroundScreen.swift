import SwiftUI
import Mirai

struct PlaygroundScreen: View {
    @EnvironmentObject var playgroundModel: PlaygroundModel
    @State var inputText = Strings.playgroundInputDefault
    @FocusState var inputFocused: Bool
    @State var result: ModelSessionResult?

    var model: Model? {
        playgroundModel.modelsService.defaultModel
    }

    var headerView: some View {
        let state = playgroundModel.modelSessionState
        return VStack(alignment: .center, spacing: 0.0) {
            HStack(alignment: .center, spacing: 0.0) {
                if let model {
                    Text(model.identifier)
                        .foregroundStyle(Colors.primary)
                        .font(Fonts.mono12Semibold)
                }
                Spacer(minLength: 0.0)
                Text(state.description)
                    .foregroundStyle(Colors.secondary)
                    .font(Fonts.mono12Semibold)
            }
            .padding(.horizontal, 16.0)
            .frame(height: 48.0)
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxWidth: .infinity, minHeight: 1.0, maxHeight: 1.0)
                .background(Colors.card)
        }
    }

    var inputView: some View {
        let state = playgroundModel.modelSessionState
        return TextView(
            placeholder: Strings.playgroundInputPlaceholder,
            placeholderColor: Colors.secondary,
            text: $inputText,
            focused: $inputFocused,
            multiline: true,
            rightView: nil
        )
        .lineLimit(10)
        .foregroundStyle(Colors.primary)
        .tint(Colors.primary)
        .submitLabel(.done)
        .font(Fonts.mono16Regular)
        .padding(EdgeInsets(top: 12.0, leading: 16.0, bottom: 12.0, trailing: 16.0))
        .background(Colors.card)
        .cornerRadius(8.0)
        .onChange(of: inputText) { oldValue, newValue in
            if oldValue != newValue, newValue.last == "\n" {
                inputText = oldValue.trimmingCharacters(in: .whitespacesAndNewlines)
                inputFocused = false
            }
        }
        .opacity(state.ready ? 1.0 : 0.5)
        .disabled(!state.ready)
    }

    func actionView(text: String) -> some View {
        Text(text)
            .font(Fonts.mono16Regular)
            .foregroundStyle(Colors.contrast)
            .padding(.horizontal, 16.0)
            .frame(height: 56.0)
            .background(Colors.primary)
            .cornerRadius(8.0)
    }

    var actionsView: some View {
        let state = playgroundModel.modelSessionState
        return HStack(alignment: .center, spacing: 0.0) {
            OpacityButton {
                result = nil
                let prompt = inputText
                Task {
                    try await run(prompt: prompt)
                }
            } content: {
                actionView(text: Strings.playgroundRun)
            }
            Spacer(minLength: 0.0)
        }
        .opacity(state.ready ? 1.0 : 0.5)
        .disabled(!state.ready)
    }

    func resultView(result: ModelSessionResult) -> some View {
        let response = result.text.trimmingCharacters(in: .whitespacesAndNewlines)
        return HStack(alignment: .center, spacing: 0.0) {
            Text(LocalizedStringKey(response))
                .font(Fonts.mono16Regular)
                .foregroundStyle(Colors.primary)
                .padding(EdgeInsets(top: 12.0, leading: 16.0, bottom: 12.0, trailing: 16.0))
                .background(Colors.card)
                .cornerRadius(8.0)
            Spacer(minLength: 0.0)
        }
    }

    var contentView: some View {
        VStack(alignment: .center, spacing: 0.0) {
            headerView
            VStack(alignment: .center, spacing: 0.0) {
                inputView
                if let result {
                    Spacer(minLength: 0.0)
                        .frame(height: 12.0)
                    resultView(result: result)
                }
                Spacer(minLength: 0.0)
                Spacer(minLength: 0.0)
                    .frame(height: 12.0)
                actionsView
            }
            .padding(16.0)
        }
    }

    var body: some View {
        contentView
            .onAppear {
                Task {
                    try await configureSession(model: model)
                }
            }
            .onDisappear {
                Task {
                    try await configureSession(model: nil)
                }
            }
    }
}

extension PlaygroundScreen {
    func configureSession(model: Model?) async throws {
        let configuration = ModelSessionConfiguration.forType(.general)
        if let modelSession = playgroundModel.modelSession, model != nil {
            try await modelSession.updateConfiguration(configuration)
            try await modelSession.reset()
        } else {
            try await playgroundModel.updateModelSession(
                model: model,
                configuration: configuration
            )
        }
    }

    func run(prompt: String) async throws {
        guard let session = playgroundModel.modelSession else {
            return
        }
        try await session.run(input: .text(prompt)) { result in
            self.result = result
        }
    }
}
