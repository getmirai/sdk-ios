import UIKit
import SwiftUI

struct Colors {
    static let background = Color(uiColor: UIColor(named: "BackgroundColor")!)
    static let card = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(hex: "#1A1A1A") : UIColor(hex: "#F4F5F5")
    })
    static let primary = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(hex: "#FFFFFF") : UIColor(hex: "#000000")
    })
    static let secondary = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(hex: "#FFFFFF", alpha: 0.48) : UIColor(hex: "#29363D", alpha: 0.56)
    })
    static let contrast = Color(uiColor: UIColor {
        $0.userInterfaceStyle == .dark ? UIColor(hex: "#000000") : UIColor(hex: "#FFFFFF")
    })
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
