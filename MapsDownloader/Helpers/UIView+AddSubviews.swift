//
//  UIView+AddSubviews.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 25.02.2025.
//

import UIKit

extension UIView {
    func addSubviewAndPin(_ view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, safeArea: Bool = false) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if safeArea {
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -bottom).isActive = true
            view.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: left).isActive = true
            view.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -right).isActive = true
        } else {
            view.topAnchor.constraint(equalTo: topAnchor, constant: top).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom).isActive = true
            view.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -right).isActive = true
        }
    }
    
    func addSubviewAndPinToCenter(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func addSubviewAndPin(_ view: UIView, padding: CGFloat, safeArea: Bool = false) {
        addSubviewAndPin(view, top: padding, left: padding, bottom: padding, right: padding, safeArea: safeArea)
    }
}
