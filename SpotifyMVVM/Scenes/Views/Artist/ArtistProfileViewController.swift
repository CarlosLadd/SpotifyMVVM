//
//  ArtistProfileViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/24/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class ArtistProfileViewController: BaseViewController {
    
    // Header View
    private var headerView: UIView = {
        let vvw = UIView()
        vvw.backgroundColor = .darkPrimary
        return vvw
    }()
    
    // Home List
    private var profileTableView: UITableView!
    private var profileCellRowId: String = "profileCellRowId"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        activeStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
        
        // UI
        renderHeaderProfileView()
        renderTableView()
        renderNavTopBar()
    }
    
    // MARK: - UI
    
    private func renderHeaderProfileView() {
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 250)
        headerView.backgroundColor = .lightGray
        
        self.view.addSubview(headerView)
    }
    
    private func renderNavTopBar() {
        let navTopBar =  UIView(frame: CGRect(x: 0, y: Static.hasTopNotch(), width: self.view.bounds.width, height: Static.margin44x))
        navTopBar.backgroundColor = .clear
        
        let backIcon = UIImageView(frame: CGRect(x: Static.margin16x,
                                                 y: (navTopBar.bounds.height / 2) - (Static.margin24x / 2),
                                                 width: Static.margin24x,
                                                 height: Static.margin24x))
        backIcon.image = #imageLiteral(resourceName: "icon-back")
        backIcon.image = backIcon.image?.withRenderingMode(.alwaysTemplate)
        backIcon.tintColor = .white
        backIcon.contentMode = .scaleAspectFit
        backIcon.isUserInteractionEnabled = true
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(didTapOnBackButtonAction(_:)))
        backTap.numberOfTouchesRequired = 1
        backTap.numberOfTapsRequired = 1
        backIcon.addGestureRecognizer(backTap)
        
        navTopBar.addSubview(backIcon)
        self.view.addSubview(navTopBar)
    }
    
    private func renderTableView() {
        let headerTableView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0))
        headerTableView.backgroundColor = .white
        
        // Round corners
        // shorturl.at/kRS36
        headerTableView.clipsToBounds = true
        headerTableView.layer.cornerRadius = Static.margin16x
        headerTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Artist Name
        let artistNameLab = UILabel(frame: CGRect(x: Static.margin16x,
                                                  y: Static.margin16x,
                                                  width: self.view.bounds.width - Static.margin32x,
                                                  height: Static.margin44x))
        artistNameLab.font = UIFont.spFont(name: .bold, size: 25)
        artistNameLab.textColor = .darkPrimary
        
        // Only for test
        artistNameLab.text = "The Chainsmokers"
        
        let songCover = UIView(frame: CGRect(x: artistNameLab.frame.origin.x,
                                             y: artistNameLab.frame.origin.y + artistNameLab.bounds.height + Static.margin10x,
                                             width: Static.margin80x,
                                             height: Static.margin80x))
        songCover.backgroundColor = .lightGray
        songCover.layer.cornerRadius = 5.0
        
        headerTableView.frame.size.height = songCover.frame.origin.y + songCover.bounds.height
        
        headerTableView.addSubview(artistNameLab)
        headerTableView.addSubview(songCover)
        
        // TableView
        profileTableView = UITableView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: self.view.frame.size.width,
                                                     height: self.view.frame.size.height),
                                                     style: .plain)
        profileTableView.backgroundView?.backgroundColor = .clear
        profileTableView.backgroundColor = .clear
        profileTableView.allowsMultipleSelection = false
        profileTableView.allowsSelection = true
        profileTableView.separatorStyle = .none
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.showsVerticalScrollIndicator = false
        profileTableView.estimatedRowHeight = 100.0
        profileTableView.rowHeight = UITableView.automaticDimension
        profileTableView.estimatedSectionFooterHeight = 0.0
        profileTableView.estimatedSectionHeaderHeight = 0.0
        profileTableView.tableHeaderView = headerTableView
        profileTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Static.hasBottomArea() + Static.margin44x))
        
        profileTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: profileCellRowId)
        profileTableView.contentInset = UIEdgeInsets(top: headerView.bounds.height - Static.hasTopNotch() - Static.margin24x,
                                                  left: 0,
                                                  bottom: 0,
                                                  right: 0)
        
        self.view.addSubview(profileTableView)
    }
    
    // MARK: - Tap Actions
    
    @objc func didTapOnBackButtonAction(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Home TableView Delegate

extension ArtistProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: profileCellRowId, for: indexPath as IndexPath) as! HomeTableViewCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetHeaderStop = headerView.bounds.height - Static.hasTopNotch() - Static.margin24x
        let totalOffset = scrollView.contentOffset.y + headerView.bounds.height - Static.margin24x
        
        // Scale and Translate.
        var headerTransform = CATransform3DIdentity
        
        if totalOffset < 0 {
            let headerScaleFactor: CGFloat = -(totalOffset) / headerView.bounds.height
            
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height) / 2
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
        } else {
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offsetHeaderStop, -totalOffset), 0)
        }
        
        let transparencyValue: CGFloat = 1 - (totalOffset / offsetHeaderStop)
        let solidValue: CGFloat = totalOffset / offsetHeaderStop
        
        if solidValue >= 1.0 {
            activeStatusBarStyle = .default
        } else {
            activeStatusBarStyle = .lightContent
        }
        
        headerView.layer.transform = headerTransform
        headerView.alpha = transparencyValue
        setNeedsStatusBarAppearanceUpdate()
    }
    
}
