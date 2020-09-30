//
//  NavigationHandler.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import UIKit

class NavigationHandler {
    
    static let shared = NavigationHandler()
    
    func initialTransition(from window: UIWindow?) {
        guard let window = window else { return }
        UIView.transition(with: window,
                          duration: 0.5,
                          options: [UIView.AnimationOptions.curveEaseOut,
                                    UIView.AnimationOptions.transitionCrossDissolve],
                          animations: {},
                          completion: { _ in
                            let mainNavigationController = BaseNavigationController()
                            
                            window.rootViewController = mainNavigationController
                            window.makeKeyAndVisible()
        })
    }
    
    // MARK: - Check After Push
    
    func checkAfterPushViewController(vcl: BaseViewController,
                                      classOf: AnyClass,
                                      weakSelf: UIViewController) {
        var vccounter = 0
        
        for focusvc in weakSelf.navigationController?.viewControllers ?? [] {
            if focusvc.isKind(of: classOf.self) {
                weakSelf.navigationController?.viewControllers.remove(at: vccounter)
                break
            }
            
            vccounter += 1
        }
        
        weakSelf.navigationController?.pushViewController(vcl, animated: true)
    }
    
}
