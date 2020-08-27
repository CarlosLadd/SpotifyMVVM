//
//  UIColor+Extension.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Common
    
    static func UIColorMake(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // MARK: - Global Colors
    
    static let darkPrimary = UIColorMake(red: 5.0, green: 21.0, blue: 35.0, alpha: 1.0)
    static let spotifyGreen = UIColorMake(red: 29.0, green: 185.0, blue: 84.0, alpha: 1.0)
    
}
