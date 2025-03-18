import SwiftUI

struct Fonts {
    static let mono12Regular = mono(size: 12.0, weight: .regular)
    static let mono12Semibold = mono(size: 12.0, weight: .semibold)
    static let mono16Regular = mono(size: 16.0, weight: .regular)
    static let mono22Semibold = mono(size: 22.0, weight: .semibold)

    private static func mono(size: CGFloat, weight: Font.Weight) -> Font {
        self.rounded(size: size, weight: weight).monospaced()
    }

    private static func rounded(size: CGFloat, weight: Font.Weight) -> Font {
        Font.system(size: size, weight: weight, design: .rounded)
    }
}
