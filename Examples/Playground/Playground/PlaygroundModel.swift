import Combine
import Mirai

final class PlaygroundModel: ObservableObject {
    struct SessionState {
        let ready: Bool
        let description: String
    }

    private var subscriptions = Set<AnyCancellable>()

    let modelsService: ModelsService
    fileprivate(set) var modelSession: (any ModelSession)?
    @MainActor var modelSessionState: SessionState {
        guard let state = modelSession?.state else {
            return .init(ready: false, description: Strings.loading)
        }
        switch state {
        case .unloaded, .loading:
            return .init(ready: false, description: Strings.loading)
        case .ready:
            return .init(ready: true, description: Strings.ready)
        case .generatingPrefill:
            return .init(ready: false, description: Strings.processing)
        case .generatingCompletion:
            return .init(ready: false, description: Strings.answering)
        case .preparing(let progress):
            return .init(ready: false, description: String(format: Strings.preparingFormat, String(format: "%.2f", progress * 100.0)))
        @unknown default:
            return .init(ready: false, description: Strings.loading)
        }
    }

    init() {
        let modelsService = ModelsService()

        self.modelsService = modelsService

        let publishers = [
            self.modelsService.objectWillChange
        ]
        for publisher in publishers {
            publisher
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &self.subscriptions)
        }
    }

    func updateModelSession(
        model: Model?,
        configuration: ModelSessionConfiguration
    ) async throws {
        await MainActor.run { [weak self] in
            self?.modelSession = nil
        }

        guard
            let model,
            let modelFiles = MiraiEngine.shared.storage.localFiles(for: model) else {
            return
        }
        let session = try await MiraiEngine.shared.session(model: model, modelFiles: modelFiles)
        try await session.updateConfiguration(configuration)
        await MainActor.run { [weak self] in
            guard let self else {
                return
            }
            session.publisher
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &self.subscriptions)
            self.modelSession = session
        }
        try await session.load()
    }
}
