//
//  VerticalCollectionView.swift
//  SpotifyMVVM
//
//  Created by Carlos Landaverde on 8/23/20.
//  Copyright © 2020 Carlos Landaverde. All rights reserved.
//

import UIKit

class VerticalCollectionView: UICollectionView {
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
      super.layoutSubviews()
       
      if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
         self.invalidateIntrinsicContentSize()
      }
       
    }
    
    override var intrinsicContentSize: CGSize {
      return collectionViewLayout.collectionViewContentSize
    }
    
}
