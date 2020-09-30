//
//  HomeBuilder.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

final class HomeBuilder {
    
    class func buildViewController() -> BaseViewController {
        let viewController = HomeViewController()
        viewController.viewModel = DIContainer.shared.resolve()
        
        return viewController
    }
    
}
