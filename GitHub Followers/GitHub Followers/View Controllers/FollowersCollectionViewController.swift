//
//  FollowersCollectionViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class FollowersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NetworkRequesterDelegate {
    var username: String!
    
    var followersPage: Int = 2
    var gotAllFollowers: Bool = false
    
    private var array: NSArray!
    var followersArray: NSArray! {
        get {
            return self.array
        }
        set {
            self.array = newValue
            if self.array.count < 99 {
                self.gotAllFollowers = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        NetworkRequester.connection.delegate = self
        self.title = "Followers"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NetworkRequester.connection.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followerSelected" {
            let vc = segue.destination as! SingleFollowerViewController
            let cell = sender as! FollowerCollectionViewCell
            vc.login = cell.login
            vc.followerImage = cell.getFollowerImage()
            vc.cellImageWasFound = cell.imageFound
        }
    }
    
    //----------UICollectionView----------
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == self.followersArray.count {
            let collectionViewWidth = collectionView.frame.size.width
            return CGSize(width: collectionViewWidth, height: collectionViewWidth/3)
        } else {
            let collectionViewWidth = collectionView.frame.size.width
            let size = collectionViewWidth*0.3
            return CGSize(width: size, height: size)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.gotAllFollowers {
            return self.followersArray.count
        }
        return self.followersArray.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == followersArray.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeMoreCell", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followerCell", for: indexPath) as! FollowerCollectionViewCell
            let dict = self.followersArray[indexPath.row] as! NSDictionary
            let noImage = UIImage(named: "nopicture")
            cell.setFollowerImage(image: noImage!)
            cell.imageFound = false
            cell.login = dict.value(forKey: "login") as! String
            cell.avatarUrl = dict.value(forKey: "avatar_url") as! String
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let followerCell = collectionView.cellForItem(at: indexPath) as? FollowerCollectionViewCell {
            self.performSegue(withIdentifier: "followerSelected", sender: followerCell)
        } else {
            NetworkRequester.connection.getFollowers(username: self.username, page: String(self.followersPage))
        }
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followersRecieved(array: NSArray) {
        if array.count > 0 {
            if array.count < 99 {
                self.gotAllFollowers = true
            } else {
                self.followersPage+=1
            }
            let newArray = NSArray(array: Array(self.followersArray) + Array(array), copyItems: false)
            self.followersArray = newArray
        } else {
            self.gotAllFollowers = true
        }
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func followerCellImageLoaded(image: UIImage, forCell cell: FollowerCollectionViewCell) {
        DispatchQueue.main.async {
            cell.setFollowerImage(image: image)
            cell.imageFound = true
        }
    }
    
    func imageRequestError(forCell cell: FollowerCollectionViewCell) {
        let noImage = UIImage(named: "nopicture")
        DispatchQueue.main.async {
            cell.setFollowerImage(image: noImage!)
            cell.imageFound = false
        }
    }
    
}
