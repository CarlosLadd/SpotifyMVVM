//
//  SpotifyLoginButton.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/26/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class SpotifyLoginButton: UIButton {

    fileprivate let buttonBackgroundColor = UIColor.spotifyGreen
    
    let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .heavy),
        .foregroundColor: UIColor.white,
        .kern: 2.0
    ]

    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: CGRect.zero)
        backgroundColor = buttonBackgroundColor
        contentEdgeInsets = UIEdgeInsets(top: 11.75, left: 32.0, bottom: 11.75, right: 32.0)
        layer.cornerRadius = 20.0
        
        let title = NSAttributedString(string: title, attributes: titleAttributes)
        setAttributedTitle(title, for: .normal)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
