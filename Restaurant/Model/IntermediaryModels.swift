//
//  Categories.swift
//  Restaurant
//
//  Created by Harsha on 24/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

struct Categories: Codable {
    let categories: [String]
}

struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}
