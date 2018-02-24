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
    
    @IBOutlet weak var statusLabel: UILabel?
    
    private var _status: String!
    var status: String! {
        get {
            return self._status
        }
        set {
            self._status = newValue
            DispatchQueue.main.async {
                self.statusLabel?.text = self.status
                if newValue == self.successText {
                    self.performSegue(withIdentifier: "followersFoundSegue", sender: self)
                }
            }
        }
    }
    
    var followersArray: NSArray!
    
    let defaultText = "Type a GitHub username in the search bar to see that user's followers!"
    let connectingText = "Please wait a moment while we look for the user's followers..."
    let successText = "Huzzah! Found user's followers!"
    let requestErrorText = "Uh-oh! There was a problem getting that user's followers, make sure you are connected to the internet and the username is spelled correctly and try again."
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusLabel?.text = self.defaultText
        self.addSearchBarButtonItems()
        NetworkRequester.connection.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NetworkRequester.connection.delegate = self
        self.usernameTextField.text = ""
        self.statusLabel?.text = self.defaultText
    }
    
    func addSearchBarButtonItems() {
        let barItemY: CGFloat = 0.0
        let barItemHeight: CGFloat = 20.0
        
        let textFieldX: CGFloat = 0.0
        let textFieldWidth: CGFloat = self.view.frame.size.width*0.6
        let textFieldFrame = CGRect(x: textFieldX, y: barItemY, width: textFieldWidth, height: barItemHeight)
        
        self.usernameTextField = UITextField(frame: textFieldFrame)
        self.usernameTextField.placeholder = "Enter GitHub Username Here"
        self.usernameTextField.borderStyle = UITextBorderStyle.roundedRect
        self.usernameTextField.backgroundColor = UIColor.darkGray
        self.usernameTextField.textColor = UIColor.lightGray
        self.usernameTextField.delegate = self
        self.usernameTextField.returnKeyType = UIReturnKeyType.done
        self.usernameTextField.keyboardAppearance = UIKeyboardAppearance.dark
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
            self.statusLabel?.text = self.connectingText
            NetworkRequester.connection.getFollowers(username: username)
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func cancelSearch() {
        self.statusLabel?.text = self.defaultText
        self.usernameTextField.resignFirstResponder()
        self.usernameTextField.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "followersFoundSegue" {
            let vc = segue.destination as! FollowersCollectionViewController
            vc.followersArray = self.followersArray
        }
    }
    
    //----------NetworkRequesterDelegate----------
    
    func followersRecieved(array: NSArray) {
        self.followersArray = array
        self.status = self.successText
    }
    
    func requestError() {
        self.status = self.requestErrorText
//        self.statusLabel?.text = self.requestErrorText
        print("Request Error")
    }
    
}
