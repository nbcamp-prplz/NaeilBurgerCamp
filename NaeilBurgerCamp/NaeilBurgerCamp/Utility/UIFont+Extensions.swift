//
//  UIFont+Extensions.swift
//  NaeilBurgerCamp
//
//  Created by 이수현 on 4/7/25.
//

import UIKit

extension UIFont {
    enum nanumSquareRoundWeight {
        case light
        case normal
        case regular
        case bold
        case extraBold
    }
    
    class func nanumSquareRound(ofSize fontSize: CGFloat,
                           weight: nanumSquareRoundWeight = .normal
    ) -> UIFont {
        switch weight {
        case .light:
            return UIFont(name: "NanumSquareRoundOTFL", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .light)
        case .normal:
            return UIFont(name: "NanumSquareRoundOTF", size: fontSize) ?? .systemFont(ofSize: fontSize)
        case .regular:
            return UIFont(name: "NanumSquareRoundOTFL", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .regular)
        case .bold:
            return UIFont(name: "NanumSquareRoundOTFB", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .bold)
        case .extraBold:
            return UIFont(name: "NanumSquareRoundOTFEB", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: .heavy)
        }
    }
}
