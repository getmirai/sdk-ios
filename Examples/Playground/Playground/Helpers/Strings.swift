import Foundation

struct Strings {
    static let installing = localized("installing")
    static let loading = localized("loading")
    static let ready = localized("ready")
    static let processing = localized("processing")
    static let answering = localized("answering")
    static let preparingFormat = localized("preparing_format")
    static let playgroundInputDefault = localized("playground_input_default")
    static let playgroundInputPlaceholder = localized("playground_input_placeholder")
    static let playgroundRun = localized("playground_run")

    private static func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
}
