//
//  Static.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import Foundation
import UIKit

open class Static : NSObject {
    
    // Singleton
    static let shared = Static()
    
    // Global Margins
    static let margin5x: CGFloat = 5.0
    static let margin10x: CGFloat = 10.0
    static let margin16x: CGFloat = 16.0
    static let margin20x: CGFloat = 20.0
    static let margin24x: CGFloat = 24.0
    static let margin32x: CGFloat = 32.0
    static let margin44x: CGFloat = 44.0
    static let margin64x: CGFloat = 64.0
    static let margin80x: CGFloat = 80.0
    static let margin112x: CGFloat = 112.0
    
    // Spotify Auth
    static let SpotifyBaseURLToken = "http://0.0.0.0"
    static let SpotifyClientID = "ab7c389908b14653b77a47ca8c82cad6"
    static let SpotifyRedirectURI = URL(string: "spotify-login-sdk-test-app://spotify-login-callback")!
    
    // MARK: - Life Cycle
    
    private override init() {
        // Code
    }
    
    // MARK: - Dynamic Width ~ Height
    
    static func widthForViewLabel(text:String, font:UIFont, height:CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.width
    }
    
    static func heightForViewLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    // MARK: - Check Navigation Stack
    
    func checkAfterPushViewController(vc: BaseViewController, classOf: AnyClass, weakSelf: UIViewController) {
        var vccounter = 0;
        
        for focusvc in weakSelf.navigationController?.viewControllers ?? [] {
            if focusvc.isKind(of: classOf.self) {
                weakSelf.navigationController?.viewControllers.remove(at: vccounter)
                break;
            }
            
            vccounter += 1
        }
        
        weakSelf.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Safe Area Margins
    
    static func hasTopNotch() -> CGFloat {
        if #available(iOS 11.0,  *) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    return sd.window?.safeAreaInsets.top ?? 0.0
                }
            }
            else {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0.0
            }
        }
        
        return 20.0
    }
    
    static func hasBottomArea() -> CGFloat {
        if #available(iOS 11.0,  *) {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                
                if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                    return sd.window?.safeAreaInsets.bottom ?? 0.0
                }
            }
            else {
                return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0.0
            }
        }
        
        return 0.0
    }
    
}
