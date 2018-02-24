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
    var avatarUrl: String {
        get {
            return self._imageurl
        }
        set {
            self._imageurl = newValue
            NetworkRequester.connection.getFollowerCellImage(requestUrl: self._imageurl, forCell: self)
        }
    }
    
    var login: String {
        get {
            return (self.followerNameLabel?.text)!
        }
        set {
            self.followerNameLabel?.text = newValue
        }
    }
    
    private var _followersurl: String!
    var followersUrl: String {
        get {
            return self._followersurl
        }
        set {
            self._followersurl = newValue
        }
    }
    
    func setFollowerImage(image: UIImage) {
        self.followerImageView?.image = image
        let layer = self.followerImageView?.layer
        layer?.masksToBounds = true
        layer?.cornerRadius = (self.followerImageView?.frame.size.height)!/2
        UIGraphicsBeginImageContext((self.followerImageView?.bounds.size)!)
        layer?.render(in: UIGraphicsGetCurrentContext()!)
    }
    
    func getFollowerImage() -> UIImage? {
        return self.followerImageView?.image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.followerImageView?.image = nil
        self.followerNameLabel?.text = ""
    }
    
}
