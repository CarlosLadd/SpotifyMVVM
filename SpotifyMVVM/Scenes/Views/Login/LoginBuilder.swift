//
//  LoginBuilder.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import UIKit

final class LoginBuilder {
    
    class func buildViewController() -> BaseViewController {
        let viewController = LoginViewController()
        viewController.viewModel = DIContainer.shared.resolve()
        
        return viewController
    }
    
}
