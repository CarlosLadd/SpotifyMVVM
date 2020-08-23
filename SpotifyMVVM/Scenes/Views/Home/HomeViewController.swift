//
//  HomeViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class HomeViewController : BaseViewController {
    
    open var headerHeightValue: CGFloat = 0.0
    
    // Header View
    private var headerView: UIView = {
        let vv = UIView()
        vv.backgroundColor = .darkPrimary
        return vv
    }()
    
    // Home List
    private var homeTableView: UITableView!
    private var homeCellRowId: String = "homeCellRowId"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // UI
        renderHeaderView()
        renderHomeTableView()
    }
    
    // MARK: - UI
    
    private func renderHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.0)
        
        /// Main Title
        
        let headerTitle = UILabel(frame: CGRect(x: Static.margin20x, y: Static.hasTopNotch() + Static.margin16x, width: headerView.bounds.width / 2, height: 0.0))
        headerTitle.font = UIFont.spFont(name: .bold, size: 24)
        headerTitle.textAlignment = .left
        headerTitle.textColor = .white
        headerTitle.text = NSLocalizedString("homeHeaderTitle", comment: "")
        
        let headerTitleHeight = Static.heightForViewLabel(text: headerTitle.text!, font: headerTitle.font!, width: headerTitle.bounds.width)
        headerTitle.frame.size.height = headerTitleHeight
        headerTitle.numberOfLines = Int(headerTitle.font.pointSize / headerTitleHeight)
        
        /// Search
        
        let searchBox = UIView(frame: CGRect(x: Static.margin20x, y: headerTitle.frame.origin.y + headerTitle.bounds.height + Static.margin16x, width: headerView.bounds.width - (Static.margin20x * 2), height: Static.margin44x))
        searchBox.backgroundColor = .white
        searchBox.layer.cornerRadius = 20.0
        
        // Set Height
        headerView.frame.size.height = searchBox.frame.origin.y + searchBox.bounds.height + Static.margin24x
        headerHeightValue = headerView.frame.size.height
        
        // Round corners
        // shorturl.at/kRS36
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = Static.margin24x
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // Render
        headerView.addSubview(headerTitle)
        headerView.addSubview(searchBox)
        
        self.view.addSubview(headerView)
    }
    
    private func renderHomeTableView() {
        homeTableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain)
        homeTableView.backgroundView?.backgroundColor = .clear
        homeTableView.backgroundColor = .clear
        homeTableView.tableFooterView = UIView()
        homeTableView.allowsMultipleSelection = false
        homeTableView.allowsSelection = true
        homeTableView.separatorStyle = .none
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.showsVerticalScrollIndicator = false
        homeTableView.estimatedRowHeight = 310.0
        homeTableView.estimatedSectionFooterHeight = 0.0
        homeTableView.estimatedSectionHeaderHeight = 0.0
    }
    
}

// MARK: - Home TableView Delegate

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // offset_HeaderStop = headerHeightValue - Static.hasTopNotch()
        return 326
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Code
    }
    
}
