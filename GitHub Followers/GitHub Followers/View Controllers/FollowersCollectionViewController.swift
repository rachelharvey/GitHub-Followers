//
//  FollowersCollectionViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class FollowersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NetworkRequesterDelegate {
    
    var followersArray: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        NetworkRequester.connection.delegate = self
    }
    
    //----------UICollectionView----------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width
        let size = collectionViewWidth*0.3
        return CGSize(width: size, height: size)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.followersArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followerCell", for: indexPath) as! FollowerCollectionViewCell
        let dict = self.followersArray[indexPath.row] as! NSDictionary
        cell.login = dict.value(forKey: "login") as! String
        cell.avatarUrl = dict.value(forKey: "avatar_url") as! String
        cell.followersUrl = dict.value(forKey: "followers_url") as! String
        return cell
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followerCellImageLoaded(image: UIImage, forCell cell: FollowerCollectionViewCell, url: String) {
        DispatchQueue.main.async {
            cell.setFollowerImage(image: image)
        }
    }
    
    func requestError() {
        print("There was an error getting an image")
    }
    
}
