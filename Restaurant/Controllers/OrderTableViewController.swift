//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Harsha on 24/07/19.
//  Copyright © 2019 Ixigo. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var menuItems: [MenuItem] = []
    var orderMinutes = 0
    
    @IBAction func submitButtonTapped(_ sender: UIBarButtonItem) {
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0) {(result, menuitem) -> Double in
                return result + menuitem.price
            }
        let formattedOrder = String(format: "$%.2f", orderTotal)
        let alert = UIAlertController(title: "Confirm Order", message: "Your are about to submit order with total value of \(formattedOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func unwindToOrderList(unwindSegue: UIStoryboardSegue) {
        if unwindSegue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    private func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map{ $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIds) {
            (preparationMinutes) in
            
            DispatchQueue.main.async {
                if let preparationMinutes = preparationMinutes {
                    self.orderMinutes = preparationMinutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        //TODO:- check force unwrap
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: MenuController.orderUpdateNotification, object: nil)
        
        menuItems =  MenuController.shared.order.menuItems
        
    }
    
    @objc func reloadData() {
        menuItems =  MenuController.shared.order.menuItems
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIndentifier", for: indexPath)
        configure(cell, forItemAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        cell.textLabel?.text = menuItems[indexPath.row].name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItems[indexPath.row].price)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
}
