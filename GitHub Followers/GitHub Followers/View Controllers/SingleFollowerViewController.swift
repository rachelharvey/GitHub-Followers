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
    var htmlUrl: String!
    
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
            self.setFollowerDataLabels()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkRequester.connection.delegate = self
        NetworkRequester.connection.getFollowerInfo(login: self.login)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.bigImageView?.image = self.followerImage
        self.setSmallImage()
        self.loginLabel?.text = self.login
    }
    
    func setSmallImage() {
        self.smallImageView?.image = self.followerImage
        let layer = self.smallImageView?.layer
        layer?.masksToBounds = true
        layer?.cornerRadius = (self.smallImageView?.frame.size.height)!/2
        UIGraphicsBeginImageContext((self.smallImageView?.bounds.size)!)
        layer?.render(in: UIGraphicsGetCurrentContext()!)
    }
    
    func setFollowerDataLabels() {
        self.nameLabel?.text = self.follower.value(forKey: "name") as? String
        self.followersNumberLabel?.text = "\(self.follower.value(forKey: "followers") as! NSNumber)"
        self.followingNumberLabel?.text = "\(self.follower.value(forKey: "following") as! NSNumber)"
        self.repositoriesNumberLabel?.text = "\(self.follower.value(forKey: "public_repos") as! NSNumber)"
        if let location = self.follower.value(forKey: "location") as? String {
            self.locationLabel?.text = location
        } else {
            self.locationLabel?.isHidden = true
            self.locationImageView?.isHidden = true
        }
        if let email = self.follower.value(forKey: "email") as? String {
            self.emailLabel?.text = email
        } else {
            self.emailLabel?.isHidden = true
            self.emailImageView?.isHidden = true
        }
        self.htmlUrl = self.follower.value(forKey: "html_url") as? String
    }
    
    @IBAction func backButtonPushed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func visitGitHubProfile() {
        if let url = URL(string: self.htmlUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followerInfoRecieved(dictionary: NSDictionary) {
        DispatchQueue.main.async {
            self.follower = dictionary
        }
    }
    
    func requestError() {
        let alert = UIAlertController(title: "Uh-oh!", message: "There was an eror getting the user's info. Please make sure device is connected to the internet.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertActionStyle.default, handler: { Void in
                NetworkRequester.connection.getFollowerInfo(login: self.login)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
