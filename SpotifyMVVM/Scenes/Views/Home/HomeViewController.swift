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
    
    // Data Sources
    private var groupsObjects = [HomeGroupModel]()
    private var categoriesArray = [CategoryModel]()
    private var songsArray = [SongModel]()
    private var recommendedArray = [SongModel]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // Data only for test
        renderDataForTest()
        
        // UI
        renderHeaderView()
        renderHomeTableView()
    }
    
    private func renderDataForTest() {
        // Categories
        categoriesArray.append(CategoryModel(coverURL: "", title: "Rock"))
        categoriesArray.append(CategoryModel(coverURL: "", title: "Country"))
        categoriesArray.append(CategoryModel(coverURL: "", title: "Jazz"))
        categoriesArray.append(CategoryModel(coverURL: "", title: "Soul"))
        categoriesArray.append(CategoryModel(coverURL: "", title: "Hip Hop"))
        
        // Songs
        songsArray.append(SongModel(coverURL: "", name: "Sucker", singer: "Jonas Brothers"))
        songsArray.append(SongModel(coverURL: "", name: "I Don't Car", singer: "Ed Sheeran & Bieber's"))
        songsArray.append(SongModel(coverURL: "", name: "Old Town Road", singer: "Lil Nas"))
        
        // Recommended
        recommendedArray.append(SongModel(coverURL: "", name: "Closer (feat. Halsey)", singer: "The Chainsmokers"))
        recommendedArray.append(SongModel(coverURL: "", name: "7 Rings", singer: "Ariana Grande's"))
        recommendedArray.append(SongModel(coverURL: "", name: "TAKI TAKI", singer: "Selena Gomez"))
        
        // Groups
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeCategoriesBlockTitle", comment: ""), groupType: .categories, objects: categoriesArray))
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeTrendingBlockTitle", comment: ""), groupType: .trending, objects: songsArray))
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeSongsRecommendedTitle", comment: ""), groupType: .recommended, objects: recommendedArray))
    }
    
    // MARK: - UI
    
    private func renderHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.0)
        
        /// Main Title
        
        let headerTitle = UILabel(frame: CGRect(x: Static.margin20x, y: Static.hasTopNotch() + Static.margin16x, width: headerView.bounds.width / 2, height: 0.0))
        headerTitle.font = UIFont.spFont(name: .bold, size: Static.margin24x)
        headerTitle.textAlignment = .left
        headerTitle.textColor = .white
        headerTitle.text = NSLocalizedString("homeHeaderTitle", comment: "")
        
        let headerTitleHeight = Static.heightForViewLabel(text: headerTitle.text!, font: headerTitle.font!, width: headerTitle.bounds.width)
        headerTitle.frame.size.height = headerTitleHeight
        headerTitle.numberOfLines = Int(headerTitle.font.pointSize / headerTitleHeight)
        
        /// Search
        
        let searchBox = UIView(frame: CGRect(x: Static.margin20x, y: headerTitle.frame.origin.y + headerTitle.bounds.height + Static.margin16x, width: headerView.bounds.width - (Static.margin20x * 2), height: Static.margin44x))
        searchBox.backgroundColor = .white
        searchBox.layer.cornerRadius = Static.margin20x
        
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
        
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellRowId)
        homeTableView.contentInset = UIEdgeInsets(top: headerView.bounds.height - Static.hasTopNotch(),
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
        
        self.view.addSubview(homeTableView)
    }
    
}

// MARK: - Home TableView Delegate

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = groupsObjects[indexPath.row]
        
        if group.groupType == .categories {
            return Static.margin112x + Static.margin32x + Static.margin16x
        }
        else if group.groupType == .trending {
            return Static.margin112x + Static.margin32x + Static.margin24x * 2
        }
        else {
            return Static.margin64x
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellRowId, for: indexPath as IndexPath) as! HomeTableViewCell
        let group = groupsObjects[indexPath.row]
        
        cell.parentViewController = self
        cell.homeGroup = group
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset_HeaderStop = headerHeightValue - Static.hasTopNotch()
        let totalOffset = scrollView.contentOffset.y + headerView.bounds.height
        
        // Scale and Translate.
        var headerTransform = CATransform3DIdentity
        
        if totalOffset < 0 {
            let headerScaleFactor:CGFloat = -(totalOffset) / headerView.bounds.height
            
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height) / 2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
        }
        else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -totalOffset), 0)
        }
        
        let transparencyValue: CGFloat = 1 - (totalOffset / offset_HeaderStop);
        let solidValue: CGFloat = totalOffset / offset_HeaderStop;
        
        if solidValue >= 1.0 {
            activeStatusBarStyle = .default
        }
        else {
            activeStatusBarStyle = .lightContent
        }
        
        headerView.layer.transform = headerTransform
        headerView.alpha = transparencyValue
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
