import SwiftUI

struct TextView: View {
    let placeholder: String
    let placeholderColor: Color
    @Binding var text: String
    @FocusState<Bool>.Binding var focused: Bool
    let multiline: Bool
    let rightView: (any View)?

    init(
        placeholder: String,
        placeholderColor: Color,
        text: Binding<String>,
        focused: FocusState<Bool>.Binding,
        multiline: Bool,
        rightView: (any View)?
    ) {
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self._text = text
        self._focused = focused
        self.multiline = multiline
        self.rightView = rightView
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0.0) {
            ZStack(alignment: .topLeading) {
                TextField("", text: $text, axis: multiline ? .vertical : .horizontal)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .focused($focused)
                Text(placeholder)
                    .foregroundStyle(placeholderColor)
                    .opacity(text.isEmpty ? 1.0 : 0.0)
                    .allowsHitTesting(false)
            }
            if let rightView {
                Spacer()
                    .frame(width: 12.0)
                AnyView(rightView)
            }
        }
    }
}
