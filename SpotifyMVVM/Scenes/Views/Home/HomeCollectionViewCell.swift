//
//  HomeCollectionViewCell.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/23/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class HomeCollectionViewCell : UICollectionViewCell {
    
    var originRect: CGSize {
        didSet {
            coverBox.frame = CGRect(x: 0, y: 0, width: originRect.width, height: originRect.height)
            categoryTitle.frame = CGRect(x: 0, y: 0, width: coverBox.bounds.width, height: coverBox.bounds.height)
            songTitle.frame = CGRect(x: 0, y: coverBox.frame.origin.y + coverBox.bounds.height, width: coverBox.bounds.width, height: Static.margin24x)
            singerName.frame = CGRect(x: 0, y: songTitle.frame.origin.y + songTitle.bounds.height, width: coverBox.bounds.width, height: Static.margin24x)
            
            songTitle.adjustsFontSizeToFitWidth = true
            songTitle.minimumScaleFactor = 0.5
            singerName.adjustsFontSizeToFitWidth = true
            singerName.minimumScaleFactor = 0.5
        }
    }
    
    var category: CategoryModel? {
        didSet {
            categoryTitle.text = category?.title
        }
    }
    
    var trending: SongModel? {
        didSet {
            songTitle.text = trending?.name
            singerName.text = trending?.singer
        }
    }
    
    // MARK: - UI
    
    public let coverBox: UIView = {
        let vv = UIView()
        vv.backgroundColor = .lightGray
        vv.layer.cornerRadius = 10.0
        vv.layer.masksToBounds = true
        return vv
    }()
    
    public let categoryTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.spFont(name: .bold, size: 16)
        return lbl
    }()
    
    public let songTitle: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .darkPrimary
        lbl.font = UIFont.spFont(name: .semiBold, size: 14)
        return lbl
    }()
    
    public let singerName: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.spFont(name: .semiBold, size: 12)
        return lbl
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        self.originRect = CGSize(width: 0.0, height: 0.0)
        super.init(frame: frame)
        
        addSubview(coverBox)
        addSubview(categoryTitle)
        addSubview(songTitle)
        addSubview(singerName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
