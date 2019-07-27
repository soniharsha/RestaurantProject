//
//  MenuController.swift
//  Restaurant
//
//  Created by Harsha on 24/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation
import UIKit

class MenuController {
    
    let baseURL = URL(string: "http://localhost:8090")!
    
    var order = Order() {
        didSet {
                NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    
    static let shared = MenuController()
    
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL) {
            (data, response, error) in
            //TODO:- Different method to decode has been used in book
            //let jsonDecoder = JSONDecoder()
//            if let data = data, let categories = try? jsonDecoder.decode(Categories.self, from: data) {
//                completion(categories.categories)
//            } else {
//                completion(nil)
//            }
            
            if let data = data {
                if let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any], let categories = jsonDictionary["categories"] as? [String] {
                    completion(categories)
                }
            }
        }
        task.resume()
    }
    
    func fetchMenuItems(for categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String : [Int]] = ["menuIds" : menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        //how data returned will contain perpTime
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let prepareTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(prepareTime.prepTime)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}
