//
//  UsernameSearchViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class UsernameSearchViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameTextField.delegate = self
        self.usernameTextField.returnKeyType = UIReturnKeyType.done
        NetworkRequestor.connection.getFollowers(username: "rachelharveyafdsfads")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(self.usernameTextField.text)
        return true
    }
    
    @IBAction func cancelSearch(_ sender: Any) {
        self.usernameTextField.resignFirstResponder()
        self.usernameTextField.text = ""
    }
}
