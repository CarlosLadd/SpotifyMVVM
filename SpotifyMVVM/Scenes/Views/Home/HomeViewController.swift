//
//  HomeViewController.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/22/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    open var headerHeightValue: CGFloat = 0.0
    
    // View Model
    var viewModel: HomeViewModelProtocol?
    
    // Header View
    private var headerView: UIView = {
        let vvw = UIView()
        vvw.backgroundColor = .darkPrimary
        return vvw
    }()
    
    let searchMusicBox: UIView = {
        let vvw = UIView()
        return vvw
    }()
    
    // Bottom View
    private var bottomView: UIView = {
        let vvw = UIView()
        vvw.backgroundColor = .white
        return vvw
    }()
    
    private lazy var pauseAndPlayButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPauseOrPlay), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var trackLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.font = UIFont.spFont(name: .semiBold, size: 14)
        trackLabel.textColor = .darkGray
        trackLabel.textAlignment = .center
        return trackLabel
    }()
    
    private lazy var trackAlbumLabel: UILabel = {
        let trackLabel = UILabel()
        trackLabel.font = UIFont.spFont(name: .regular, size: 12)
        trackLabel.textColor = .lightGray
        trackLabel.textAlignment = .center
        return trackLabel
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
        renderBottomView()
        
        setupBindables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // SP View State
        Static.shared.spotifyViewStateDelegate = self
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
        recommendedArray.append(SongModel(coverURL: "", name: "Original Love", singer: "U2"))
        
        // Groups
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeCategoriesBlockTitle", comment: ""),
                                            groupType: .categories,
                                            objects: categoriesArray))
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeTrendingBlockTitle", comment: ""),
                                            groupType: .trending,
                                            objects: songsArray))
        groupsObjects.append(HomeGroupModel(groupName: NSLocalizedString("homeSongsRecommendedTitle", comment: ""),
                                            groupType: .recommended,
                                            objects: recommendedArray))
    }
    
    // MARK: - Reactive Behaviour
    
    private func setupBindables() {
        
        // Get Categories
        viewModel?.getCategories()
        
        // Get Hot Trending
        viewModel?.getHotTrendingSongs()
        
        // Get Recommended Songs
        viewModel?.getRecommendedSongs()
    }
    
    // MARK: - UI
    
    private func renderHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0.0)
        
        // Main Title
        let headerTitle = UILabel(frame: CGRect(x: Static.margin20x,
                                                y: Static.hasTopNotch() + Static.margin16x,
                                                width: headerView.bounds.width / 2,
                                                height: 0.0))
        headerTitle.font = UIFont.spFont(name: .bold, size: Static.margin24x)
        headerTitle.textAlignment = .left
        headerTitle.textColor = .white
        headerTitle.text = NSLocalizedString("homeHeaderTitle", comment: "")
        
        let headerTitleHeight = Static.heightForViewLabel(text: headerTitle.text!, font: headerTitle.font!, width: headerTitle.bounds.width)
        headerTitle.frame.size.height = headerTitleHeight
        headerTitle.numberOfLines = Int(headerTitle.font.pointSize / headerTitleHeight)
        
        // Search
        searchMusicBox.frame = CGRect(x: Static.margin20x,
                                      y: headerTitle.frame.origin.y + headerTitle.bounds.height + Static.margin16x,
                                      width: headerView.bounds.width - (Static.margin20x * 2),
                                      height: Static.margin44x)
        searchMusicBox.backgroundColor = .white
        searchMusicBox.layer.cornerRadius = Static.margin20x
        
        let searchIcon = UIImageView(frame: CGRect(x: Static.margin16x,
                                                   y: (searchMusicBox.bounds.height / 2) - (Static.margin24x / 2),
                                                   width: Static.margin24x,
                                                   height: Static.margin24x))
        searchIcon.image = #imageLiteral(resourceName: "icon-search")
        searchIcon.image = searchIcon.image?.withRenderingMode(.alwaysTemplate)
        searchIcon.tintColor = .lightGray
        searchIcon.contentMode = .scaleAspectFit
        
        let marginIconSearch: CGFloat = searchIcon.frame.origin.x + searchIcon.bounds.width
        let searchPlaceHolder = UILabel(frame: CGRect(x: searchIcon.frame.origin.y + searchIcon.bounds.width + Static.margin16x,
                                                      y: 0,
                                                      width: searchMusicBox.bounds.width - (marginIconSearch + Static.margin32x),
                                                      height: searchMusicBox.bounds.height))
        searchPlaceHolder.font = UIFont.spFont(name: .regular, size: 16)
        searchPlaceHolder.textColor = .lightGray
        searchPlaceHolder.text = NSLocalizedString("homeSearchPlaceHolder", comment: "")
        
        // Set Height
        headerView.frame.size.height = searchMusicBox.frame.origin.y + searchMusicBox.bounds.height + Static.margin24x
        headerHeightValue = headerView.frame.size.height
        
        // Round corners
        // shorturl.at/kRS36
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = Static.margin24x
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // Render
        searchMusicBox.addSubview(searchIcon)
        searchMusicBox.addSubview(searchPlaceHolder)
        
        headerView.addSubview(headerTitle)
        headerView.addSubview(searchMusicBox)
        
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
        homeTableView.estimatedRowHeight = 100.0
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.estimatedSectionFooterHeight = 0.0
        homeTableView.estimatedSectionHeaderHeight = 0.0
        homeTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: Static.hasBottomArea() + Static.margin44x))
        
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellRowId)
        homeTableView.contentInset = UIEdgeInsets(top: headerView.bounds.height - Static.hasTopNotch(),
                                                  left: 0,
                                                  bottom: Static.margin44x,
                                                  right: 0)
        
        self.view.addSubview(homeTableView)
    }
    
    private func renderBottomView() {
        bottomView.frame = CGRect(x: 0,
                                  y: self.view.bounds.height - (Static.margin44x + Static.hasBottomArea()),
                                  width: self.view.bounds.width,
                                  height: Static.margin44x + Static.hasBottomArea())
        
        pauseAndPlayButton.frame = CGRect(x: bottomView.bounds.width - Static.margin44x,
                                          y: (Static.margin44x / 2) - (Static.margin32x / 2),
                                          width: Static.margin32x,
                                          height: Static.margin32x)
        
        imageView.frame = CGRect(x: 0, y: 0, width: Static.margin44x, height: Static.margin44x)
        
        trackLabel.frame = CGRect(x: imageView.frame.origin.x + imageView.frame.size.width,
                                  y: 0,
                                  width: bottomView.frame.size.width - (imageView.frame.origin.x + imageView.frame.size.width + Static.margin44x),
                                  height: Static.margin44x / 2)
        
        trackAlbumLabel.frame = CGRect(x: trackLabel.frame.origin.x,
                                       y: trackLabel.frame.origin.y + trackLabel.bounds.height,
                                       width: trackLabel.bounds.width,
                                       height: trackLabel.bounds.height)
        
        bottomView.addSubview(imageView)
        bottomView.addSubview(pauseAndPlayButton)
        bottomView.addSubview(trackLabel)
        bottomView.addSubview(trackAlbumLabel)
        
        self.view.addSubview(bottomView)
    }
    
    // MARK: - Update Player State
    
    func updatePlayerState(playerState: SPTAppRemotePlayerState) {
        if Static.shared.lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        
        Static.shared.lastPlayerState = playerState
        trackLabel.text = playerState.track.name
        trackAlbumLabel.text = String(format: "%@ - %@", playerState.track.artist.name, playerState.track.album.name)
        
        if playerState.isPaused {
            pauseAndPlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        } else {
            pauseAndPlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    func fetchArtwork(for track: SPTAppRemoteTrack) {
        Static.shared.appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                self?.imageView.image = image
            }
        })
    }
    
    // MARK: - Actions
    
    @objc func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = Static.shared.lastPlayerState, lastPlayerState.isPaused {
            Static.shared.appRemote.playerAPI?.resume(nil)
        } else {
            Static.shared.appRemote.playerAPI?.pause(nil)
        }
    }
    
    // MARK: - Show Artist Profile
    
    func renderArtistProfile() {
        NavigationHandler.shared
            .checkAfterPushViewController(vcl: ArtistProfileViewController(),
                                          classOf: ArtistProfileViewController.self,
                                          weakSelf: self)
    }
    
}

// MARK: - Home TableView Delegate

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let group = groupsObjects[indexPath.row]
        
        if group.groupType == .categories {
            return Static.margin112x + Static.margin32x + Static.margin16x
            
        } else if group.groupType == .trending {
            return Static.margin112x + Static.margin32x + Static.margin24x * 2
            
        } else {
            return CGFloat(group.objects.count) * Static.margin64x
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
        let offsetHeaderStop = headerHeightValue - Static.hasTopNotch()
        let totalOffset = scrollView.contentOffset.y + headerView.bounds.height
        
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

// MARK: - Spotify View State Delegate

extension HomeViewController: SpotifyViewStateDelegate {
    
    // Session Manager
    
    func spotifySessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        // Empty
    }
    
    func spotifySessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        // Empty
    }
    
    func spotifySessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        // Empty
    }
    
    // Player State
    
    func update(playerState: SPTAppRemotePlayerState) {
        self.updatePlayerState(playerState: playerState)
    }
    
    // App Remote
    
    func spotifyAppRemoteDidConnected() {
        print(#function)
    }
    
    func spotifyAppRemoteDidOffline() {
        print(#function)
    }
    
}
