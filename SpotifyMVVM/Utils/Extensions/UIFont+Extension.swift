//
//  UIFont+Extension.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

enum AssetFont {
    case light
    case regular
    case semiBold
    case bold
}

extension UIFont {
    
    static func spFont(name: AssetFont, size: CGFloat) -> UIFont? {
        switch name {
            case .light:
                return UIFont(name: "SourceSansPro-Light", size: size)
            case .regular:
                return UIFont(name: "SourceSansPro-Regular", size: size)
            case .semiBold:
                return UIFont(name: "SourceSansPro-SemiBold", size: size)
            case .bold:
                return UIFont(name: "SourceSansPro-Bold", size: size)
        }
    }
    
}
