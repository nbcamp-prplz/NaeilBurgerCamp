import UIKit

extension UIFont {
    enum nanumSquareRoundWeight: String {
        case light = "L"
        case regular = "R"
        case bold = "B"
        case heavy = "EB"
        
        var uiFontWeight: UIFont.Weight {
            switch self {
            case .light:
                return .light
            case .regular:
                return .regular
            case .bold:
                return .bold
            case .heavy:
                return .heavy
            }
        }
    }
    
    static func nanumSquareRound(
        ofSize fontSize: CGFloat,
        weight: nanumSquareRoundWeight = .regular
    ) -> UIFont {
        return UIFont(name: "NanumSquareRoundOTF\(weight.rawValue)", size: fontSize)
            ?? .systemFont(ofSize: fontSize, weight: weight.uiFontWeight)
    }
}
