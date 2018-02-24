//
//  SingleFollowerViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class SingleFollowerViewController: UIViewController, NetworkRequesterDelegate {
    
    @IBOutlet weak var bigImageView: UIImageView?
    @IBOutlet weak var smallImageView: UIImageView?
    @IBOutlet weak var loginLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var followersNumberLabel: UILabel?
    @IBOutlet weak var followingNumberLabel: UILabel?
    @IBOutlet weak var repositoriesNumberLabel: UILabel?
    @IBOutlet weak var locationImageView: UIImageView?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var emailImageView: UIImageView?
    @IBOutlet weak var emailLabel: UILabel?
    
    private var _login: String!
    var login: String {
        get {
            return self._login
        }
        set {
            self._login = newValue
            NetworkRequester.connection.delegate = self
            NetworkRequester.connection.getFollowerInfo(login: newValue)
        }
    }
    
    private var _image: UIImage!
    var followerImage: UIImage! {
        get {
            return self._image
        }
        set {
            self._image = newValue
        }
    }
    
    private var _follower: NSDictionary!
    var follower: NSDictionary {
        get {
            return self._follower
        }
        set {
            self._follower = newValue
            print(newValue)
            DispatchQueue.main.async {
                self.nameLabel?.text = newValue.value(forKey: "name") as? String
                self.followersNumberLabel?.text = "\(newValue.value(forKey: "followers") as! NSNumber)"
                self.followingNumberLabel?.text = "\(newValue.value(forKey: "following") as! NSNumber)"
                self.repositoriesNumberLabel?.text = "\(newValue.value(forKey: "public_repos") as! NSNumber)"
                if let location = newValue.value(forKey: "location") as? String {
                    self.locationLabel?.text = location
                } else {
                    self.locationLabel?.isHidden = true
                    self.locationImageView?.isHidden = true
                }
                if let email = newValue.value(forKey: "email") as? String {
                    self.emailLabel?.text = email
                } else {
                    self.emailLabel?.isHidden = true
                    self.emailImageView?.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkRequester.connection.delegate = self
        NetworkRequester.connection.getFollowerInfo(login: self.login)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.bigImageView?.image = self.followerImage
        self.smallImageView?.image = self.followerImage
        self.loginLabel?.text = self.login
    }
    
    @IBAction func backButtonPushed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followerInfoRecieved(dictionary: NSDictionary) {
        self.follower = dictionary
    }
    
    func requestError() {
        print("Request Error")
    }
}
