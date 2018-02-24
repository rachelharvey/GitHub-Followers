//
//  NetworkRequestor.swift
//  GitHub Followers
//
//  Created by Rachel Harvey on 2/23/18.
//  Copyright © 2018 Rachel Harvey. All rights reserved.
//

import UIKit

@objc protocol NetworkRequesterDelegate {
    @objc optional func followersRecieved(array: NSArray)
    @objc optional func followerCellImageLoaded(image: UIImage, forCell cell: FollowerCollectionViewCell, url: String)
    @objc optional func followerInfoRecieved(dictionary: NSDictionary)
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
    
    private func serializeDictionary(data: NSData) -> NSDictionary? {
        var json: NSDictionary?
        do {
            json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? NSDictionary
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
                        self.delegate?.followersRecieved!(array: jsonArray)
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
    
    func getFollowerCellImage(requestUrl: String, forCell cell:FollowerCollectionViewCell) {
        if let url = URL(string: requestUrl) {
            let task = self.session.dataTask(with: url) {
                data, response, error in
                if let HTTPResponse = response as? HTTPURLResponse {
                    let statusCode = HTTPResponse.statusCode
                    if (statusCode == 200 && error == nil && data != nil){
                        if let image = UIImage(data: data!) {
                            self.delegate?.followerCellImageLoaded!(image: image, forCell: cell, url: requestUrl)
                        } else {
                            self.delegate?.requestError()
                        }
                    } else {
                        self.delegate?.requestError()
                    }
                } else {
                    self.delegate?.requestError()
                }
            }
            task.resume()
        } else {
            self.delegate?.requestError()
        }
    }
    
    func getFollowerInfo(login: String) {
        let urlString = "https://api.github.com/users/"+login
        if let url = URL(string: urlString) {
            let task = self.session.dataTask(with: url) {
                data, response, error in
                if (error == nil) {
                    if let jsonDictionary = self.serializeDictionary(data: data! as NSData) {
                        self.delegate?.followerInfoRecieved!(dictionary: jsonDictionary)
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
