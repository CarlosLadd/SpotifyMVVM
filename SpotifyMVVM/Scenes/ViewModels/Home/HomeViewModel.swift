//
//  HomeViewModel.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/24/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

final class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Initializers
    
    init() {
        // Code
    }
    
    // MARK: - HomeViewModelProtocol
    
    func getCategories() {
        print(#function)
    }
    
    func getHotTrendingSongs() {
        print(#function)
    }
    
    func getRecommendedSongs() {
        print(#function)
    }
    
}
