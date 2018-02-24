//
//  SingleFollowerViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class SingleFollowerViewController: UIViewController, NetworkRequesterDelegate {
    
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
    
    private var _follower: NSDictionary!
    var follower: NSDictionary {
        get {
            return self._follower
        }
        set {
            self._follower = newValue
            print(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkRequester.connection.delegate = self
        //NetworkRequester.connection.getFollowerInfo(login: self.login)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followerInfoRecieved(dictionary: NSDictionary) {
        self.follower = dictionary
    }
    
    func requestError() {
        print("Request Error")
    }
}
