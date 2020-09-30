//
//  SceneAssembly.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation
import Swinject

class SceneAssembly: Assembly {
    
    func assemble(container: Container) {
        let assemblies: [Assembly] = [
            LoginAssembly(),
            HomeAssembly()
        ]
        
        assemblies.forEach { $0.assemble(container: container) }
    }
    
}
