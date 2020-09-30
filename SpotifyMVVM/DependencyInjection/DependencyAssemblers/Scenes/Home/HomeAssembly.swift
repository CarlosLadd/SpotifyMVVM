//
//  HomeAssembly.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation
import Swinject

class HomeAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(HomeViewModelProtocol.self) { _ in
            return HomeViewModel()
        }
    }
    
}
