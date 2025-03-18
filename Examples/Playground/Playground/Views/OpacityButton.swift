import SwiftUI

struct OpacityButtonStyle<Content: View>: ButtonStyle {
    let content: Content

    init(content: Content) {
        self.content = content
    }

    func makeBody(configuration: Configuration) -> some View {
        self.content
            .opacity(configuration.isPressed ? 0.75 : 1.0)
    }
}

struct OpacityButton<Content: View>: View {
    private let actionBlock: () -> Void
    private let content: Content

    init(actionBlock: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.actionBlock = actionBlock
        self.content = content()
    }

    var body: some View {
        Button("") {
            let transaction = Transaction(animation: .easeInOut(duration: 0.2))
            withTransaction(transaction) {
                self.actionBlock()
            }
        }
        .buttonStyle(OpacityButtonStyle(content: self.content))
    }
}
