import Combine
import Foundation
import Mirai

final class ModelsService: ObservableObject {
    @Published var status: ModelsStorageLoadingStatus?

    let models: [Model] = [
        ModelsRegistry.llama_3_2_1b_instruct
    ]

    var defaultModel: Model? {
        self.models.first { model in
            (model.engine == .mirai) && (model.architecture == .llama3)
        }
    }

    func download() async throws {
        let status: ModelsStorageLoadingStatus? = await MainActor.run { [weak self] in
            self?.status
        }
        guard status == nil else {
            return
        }

        for model in models {
            _ = try await MiraiEngine.shared.storage.download(model: model) { [weak self] status in
                self?.status = status
            }
        }
        
        await MainActor.run { [weak self] in
            self?.status = nil
        }
    }
}
