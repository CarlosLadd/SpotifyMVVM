//
//  BaseViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    open var activeStatusBarStyle: UIStatusBarStyle = .lightContent
    
    // MARK: - Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return activeStatusBarStyle
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
