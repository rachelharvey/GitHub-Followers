//
//  NetworkRequestor.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import Foundation

@objc protocol NetworkRequesterDelegate {
    func followersRecieved(array: NSArray)
    func requestError()
}

class NetworkRequester {
    static let connection = NetworkRequester()
    
    var delegate: NetworkRequesterDelegate?
    private var session: URLSession!
    
    init() {
        self.session = URLSession.shared
        self.session.configuration.isDiscretionary = true
    }
    
    private func serializeJSON(data: NSData) -> NSArray? {
        var json: NSArray?
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? NSArray
        } catch {
            json = nil
        }
        return json
    }
    
    func getFollowers(username: String) {
        let urlString = "https://api.github.com/users/"+username+"/followers"
        if let url = URL(string: urlString) {
            let task = self.session.dataTask(with: url) {
                data, response, error in
                if (error == nil) {
                    if let jsonArray = self.serializeJSON(data: data! as NSData) {
                        self.delegate?.followersRecieved(array: jsonArray)
                    } else {
                        self.delegate?.requestError()
                    }
                } else {
                    self.delegate?.requestError()
                }
            }
            task.resume()
        }
    }
}
