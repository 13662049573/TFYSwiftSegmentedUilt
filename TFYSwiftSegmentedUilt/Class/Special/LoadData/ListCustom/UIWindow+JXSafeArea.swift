//
//  UIWindow+TFYSwiftSafeArea.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import Foundation
import UIKit

extension UIWindow {
    func sg_layoutinsets() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            if safeAreaInsets.bottom > 0 {
                return safeAreaInsets
            }else {
                return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
            }
        }
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    func sg_navigationHeight() -> CGFloat {
        return sg_layoutinsets().top + 44
    }
}
