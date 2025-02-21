//
//  UITableView.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public extension UITableView {
    func dequeueReusableCell<T>(_ object: T.Type, identifier: String = T.classString) -> T where T: UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? T else {
            assertionFailure("Class \(T.classString) is not defined")
            return T.init()
        }
        return cell
    }
}
