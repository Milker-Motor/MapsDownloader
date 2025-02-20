//
//  ViewController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import UIKit

public final class DownloadMapsViewController: UIViewController {
    public override var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    private lazy var topBanner: UIView = {
        let view = UIView()
        
        view.backgroundColor = .navigationBar
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(topBanner)
        topBanner.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            topBanner.topAnchor.constraint(equalTo: view.topAnchor),
            topBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBanner.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.bottomAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: topBanner.leadingAnchor, constant: 16)
        ])
    }
}
