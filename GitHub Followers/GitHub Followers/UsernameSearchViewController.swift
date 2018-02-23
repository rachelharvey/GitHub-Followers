//
//  UsernameSearchViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class UsernameSearchViewController: UIViewController,UITextFieldDelegate,NetworkRequestorDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.usernameTextField.returnKeyType = UIReturnKeyType.done
        NetworkRequestor.connection.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let username = self.usernameTextField.text {
            NetworkRequestor.connection.getFollowers(username: username)
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        self.usernameTextField.resignFirstResponder()
        self.usernameTextField.text = ""
    }
    
    //----------NetworkRequestorDelegate----------
    
    func followersRecieved(array: NSArray) {
        print(array)
    }
    
    func requestError() {
        print("Request Error")
    }
    
}
