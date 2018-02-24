//
//  FollowerCollectionViewCell.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class FollowerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var followerImageView: UIImageView?
    @IBOutlet weak var followerNameLabel: UILabel?
    
    private var _imageurl: String!
    var imageUrl: String {
        get {
            return self._imageurl
        }
        set {
            self._imageurl = newValue
        }
    }
    
    var followerName: String {
        get {
            return (self.followerNameLabel?.text)!
        }
        set {
            self.followerNameLabel?.text = newValue
        }
    }
    
}
