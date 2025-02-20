//
//  ViewController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 19.02.2025.
//

import UIKit

public protocol DownloadMapsViewControllerDelegate {
    func didRequestMapsLoad()
}

public final class DownloadMapsViewController: UIViewController {
    public var delegate: DownloadMapsViewControllerDelegate?
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
    
    public var refreshControl: UIRefreshControl? {
        get { mapsController.refreshControl }
        set { mapsController.refreshControl = newValue }
    }
    private lazy var mapsController = MapsTableViewController()
    
    private var onViewIsAppearing: ((DownloadMapsViewController) -> Void)? = nil
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        
        onViewIsAppearing = { vc in
            vc.refresh()
            vc.onViewIsAppearing = nil
        }
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    private func setupUI() {
        view.addSubview(topBanner)
        topBanner.addSubview(titleLabel)
        view.addSubview(mapsController.tableView)
        
        NSLayoutConstraint.activate([
            topBanner.topAnchor.constraint(equalTo: view.topAnchor),
            topBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBanner.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.bottomAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: topBanner.leadingAnchor, constant: 16),
            
            topBanner.bottomAnchor.constraint(equalTo: mapsController.tableView.topAnchor),
            mapsController.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapsController.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapsController.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func refresh() {
        delegate?.didRequestMapsLoad()
    }
}

extension DownloadMapsViewController: MapsLoadingView {
    public func display(_ viewModel: MapsLoadingViewModel) {
        viewModel.isLoading ? refreshControl?.beginRefreshing() : refreshControl?.endRefreshing()
    }
}
