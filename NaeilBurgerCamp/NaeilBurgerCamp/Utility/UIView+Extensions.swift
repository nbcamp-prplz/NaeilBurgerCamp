//
//  UIView+Extensions.swift
//  NaeilBurgerCamp
//
//  Created by 송규섭 on 4/8/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
