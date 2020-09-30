//
//  HomeViewModelProtocol.swift
//  SpotifyMVVM
//
//  Created by Manuel Landaverde on 9/25/20.
//  Copyright © 2020 Manuel Landaverde. All rights reserved.
//

import Foundation

protocol HomeViewModelProtocol {
    
    func getCategories()
    
    func getHotTrendingSongs()
    
    func getRecommendedSongs()
    
}
