//
//  UsernameSearchViewController.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

class UsernameSearchViewController: UIViewController,UITextFieldDelegate,NetworkRequesterDelegate {
    
    var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSearchBarButtonItems()
        NetworkRequester.connection.delegate = self
    }
    
    func addSearchBarButtonItems() {
        let barItemY: CGFloat = 0.0
        let barItemHeight: CGFloat = 20.0
        
        let textFieldX: CGFloat = 0.0
        let textFieldWidth: CGFloat = self.view.frame.size.width*0.6
        let textFieldFrame = CGRect(x: textFieldX, y: barItemY, width: textFieldWidth, height: barItemHeight)
        
        self.usernameTextField = UITextField(frame: textFieldFrame)
        self.usernameTextField.placeholder = "Enter GitHub Username Here"
        self.usernameTextField.delegate = self
        self.usernameTextField.returnKeyType = UIReturnKeyType.done
        let leftItem = UIBarButtonItem(customView: self.usernameTextField)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let buttonWidth: CGFloat = self.view.frame.size.width*0.3
        let buttonX: CGFloat = self.view.frame.size.width-buttonWidth
        let cancelButtonFrame = CGRect(x: buttonX, y: barItemY, width: buttonWidth, height: barItemHeight)
        let cancelButton = UIButton(frame: cancelButtonFrame)
        cancelButton.titleLabel?.numberOfLines = 1
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(UsernameSearchViewController.cancelSearch), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let username = self.usernameTextField.text {
            NetworkRequester.connection.getFollowers(username: username)
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func cancelSearch() {
        self.usernameTextField.resignFirstResponder()
        self.usernameTextField.text = ""
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followersRecieved(array: NSArray) {
        print(array)
    }
    
    func requestError() {
        print("Request Error")
    }
    
}
