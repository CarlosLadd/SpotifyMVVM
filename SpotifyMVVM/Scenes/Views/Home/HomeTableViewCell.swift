//
//  HomeTableViewCell.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/23/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class HomeTableViewCell : UITableViewCell {
    
    var parentViewController : UIViewController!
    
    var homeGroup : HomeGroupModel? {
        didSet {
            // Fix safe area width
            let ws: CGFloat = UIScreen.main.bounds.size.width
            var heightBox: CGFloat = 0.0
            
            groupNameLab.text = homeGroup?.groupName
            sourceArray = homeGroup?.objects
            activeGroupType = homeGroup?.groupType
            
            if activeGroupType == .recommended {
                collectionViewLayout.scrollDirection = .vertical
                let countObjects = homeGroup?.objects.count ?? 0
                heightBox = CGFloat(countObjects) * Static.margin64x
            }
            else if activeGroupType == .categories {
                collectionViewLayout.scrollDirection = .horizontal
                heightBox = Static.margin112x + Static.margin32x + Static.margin16x
            }
            else {
                heightBox = Static.margin112x + Static.margin24x * 2
            }
            
            groupBox.frame = CGRect(x: 0, y: 0, width: ws, height: heightBox)
            groupNameLab.frame = CGRect(x: Static.margin16x, y: 0, width: groupBox.bounds.width - Static.margin32x, height: Static.margin32x)
            
            collectionView.frame = CGRect(x: 0, y: groupNameLab.frame.origin.y + groupNameLab.bounds.height, width: groupBox.bounds.width, height: groupBox.bounds.height)
        }
    }
    
    // Group Type
    var activeGroupType: HomeGroupType?
    
    // MARK: - UI
    
    private let groupBox: UIView = {
        let vv = UIView()
        vv.backgroundColor = .clear
        return vv
    }()
    
    public let groupNameLab: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.spFont(name: .bold, size: 16)
        lbl.textColor = .darkPrimary
        return lbl
    }()
    
    // Collection View
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let cv = UICollectionViewFlowLayout()
        cv.sectionInset = UIEdgeInsets.zero
        cv.minimumLineSpacing = 0
        cv.minimumInteritemSpacing = 0
        cv.scrollDirection = .horizontal
        cv.estimatedItemSize = CGSize(width: 1, height: 1)
        return cv
    }()
    
    public let collectionViewRowId: String = "homeGroupRowId"
    
    open var collectionView: VerticalCollectionView!
    
    // Sources
    public var sourceArray: [Any]?
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Collection View
        collectionView = VerticalCollectionView(frame: CGRect(x: 0, y: groupNameLab.frame.origin.y + groupNameLab.bounds.height, width: groupBox.bounds.width, height: groupBox.bounds.height - groupNameLab.bounds.height), collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .normal
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: collectionViewRowId)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: Static.margin16x, bottom: 0, right: 0)
        
        // Render
        groupBox.addSubview(groupNameLab)
        groupBox.addSubview(collectionView)
        
        addSubview(groupBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Collection View Delegate

extension HomeTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewRowId, for: indexPath) as! HomeCollectionViewCell
        
        cell.originRect = CGSize(width: Static.margin112x, height: Static.margin112x)
        cell.backgroundColor = .clear
        
        if activeGroupType == .categories {
            let category = sourceArray?[indexPath.row] as! CategoryModel
            cell.category = category
        }
        else if activeGroupType == .trending {
            let trending = sourceArray?[indexPath.row] as! SongModel
            cell.trending = trending
        }
        else {
            cell.originRect = CGSize(width: UIScreen.main.bounds.size.width, height: Static.margin64x)
            let recommended = sourceArray?[indexPath.row] as! SongModel
            cell.recommended = recommended
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ws: CGFloat = UIScreen.main.bounds.size.width
        
        if activeGroupType == .categories {
            return CGSize(width: Static.margin112x + Static.margin16x, height: collectionView.frame.height)
        }
        else if activeGroupType == .trending {
            return CGSize(width: Static.margin112x + Static.margin16x, height: Static.margin112x + Static.margin24x * 2)
        }
        else {
            return CGSize(width: ws - Static.margin16x, height: Static.margin64x)
        }
    }
    
}
