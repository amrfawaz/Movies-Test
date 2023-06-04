//
//  UITableViewController+Extension.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 03/06/2023.
//

import UIKit
extension UITableViewCell {
    /// - Note: Used to Register cell to the passed tableview
    /// - Warning: Name Of the class should be the same as the name of Cell Identifier
    class func register(on tableView: UITableView) {
        tableView.register(UINib(nibName: self.className, bundle: nil), forCellReuseIdentifier: self.className)
    }
}
