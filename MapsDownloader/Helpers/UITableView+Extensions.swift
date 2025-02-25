//
//  UITableView+Extensions.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import UIKit

extension UITableView {
    func register(_ object: UITableViewCell.Type) {
        register(object, forCellReuseIdentifier: object.classString)
    }
    
    func dequeueReusableCell<T>(_ object: T.Type, identifier: String = T.classString) -> T where T: UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            assertionFailure("Class \(T.classString) is not defined")
            return T.init()
        }
        return cell
    }
}
