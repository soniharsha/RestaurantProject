//
//  OrderConfrimationViewController.swift
//  Restaurant
//
//  Created by Harsha on 25/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import Foundation
import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank You for placing order. Your wait time is \(minutes!)"
    }
    
}
