//
//  Order.swift
//  Restaurant
//
//  Created by Harsha on 24/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem] 
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
