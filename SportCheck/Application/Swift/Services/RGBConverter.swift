import UIKit

struct RGBConverter {
    
    static func getColorFrom(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    static func getCoreColorFrom(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> CGColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0).cgColor
    }
}

