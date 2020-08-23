//
//  HomeGroupModel.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/23/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import Foundation

enum HomeGroupType: Int {
    case categories = 1
    case trending = 2
    case recommended = 3
}

struct HomeGroupModel {
    var groupName: String
    var groupType: HomeGroupType
    var objects: [Any]
}
