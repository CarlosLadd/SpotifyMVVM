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
            groupNameLab.text = homeGroup?.groupName
        }
    }
    
    // MARK: - UI
    
    private let groupBox: UIView = {
        let vv = UIView()
        vv.backgroundColor = .clear
        return vv
    }()
    
    public let groupNameLab: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.spFont(name: .semiBold, size: 16)
        lbl.textColor = .darkPrimary
        return lbl
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let ws: CGFloat = UIScreen.main.bounds.size.width
        
        groupBox.frame = CGRect(x: 0, y: Static.margin16x, width: ws, height: 112 + Static.margin16x * 3)
        groupNameLab.frame = CGRect(x: Static.margin16x, y: 0, width: groupBox.bounds.width - Static.margin32x, height: Static.margin32x)
        
        groupBox.addSubview(groupNameLab)
        addSubview(groupBox)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
