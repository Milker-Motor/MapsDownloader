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
    
    private (set) public var errorView: UIViewController?
        
    public var refreshControl: UIRefreshControl? {
        get { mapsController.refreshControl }
        set { mapsController.refreshControl = newValue }
    }

    lazy var mapsController = MapsTableViewController()
    
    public var tableView: UITableView {
        mapsController.tableView
    }
    private var onViewIsAppearing: ((DownloadMapsViewController) -> Void)? = nil
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        setupUI()
        
        onViewIsAppearing = { vc in
            vc.refresh()
            vc.onViewIsAppearing = nil
        }
        mapsController.display([CellController(id: UUID(), StorageCellController())])
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        onViewIsAppearing?(self)
    }
    
    private func setupUI() {
        view.addSubview(topBanner)
        topBanner.addSubview(titleLabel)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            topBanner.topAnchor.constraint(equalTo: view.topAnchor),
            topBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBanner.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.bottomAnchor.constraint(equalTo: topBanner.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: topBanner.leadingAnchor, constant: 16),
            
            topBanner.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(StorageTableViewCell.self)
        tableView.register(MapTableViewCell.self)
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

extension DownloadMapsViewController: MapsErrorView {
    public func display(_ viewModel: MapsErrorViewModel) {
        let alertController = UIAlertController(title: "Error", message: viewModel.text, preferredStyle: .alert)
        
        let retry = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.refresh()
            self?.errorView = nil
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.errorView = nil
            
        }
        
        alertController.addAction(retry)
        alertController.addAction(cancel)
        errorView = alertController
        present(alertController, animated: true)
    }
}

final class DetailMapViewAdapter: MapView {
    private weak var controller: MapsTableViewController?
    private let selection: (Map) -> Void
    
    init(controller: MapsTableViewController, selection: @escaping (Map) -> Void) {
        self.controller = controller
        self.selection = selection
    }
    
    public func display(_ viewModel: MapsViewModel) {
        let mapsSection = viewModel.maps.map { viewModel in
            CellController(id: viewModel, MapCellController(model: viewModel, selection: selection))
        }
        
        controller?.display(mapsSection)
        
    }
}

final class MapViewAdapter: MapView {
    private weak var controller: MapsTableViewController?
    private let selection: (Map) -> Void
    
    init(controller: MapsTableViewController, selection: @escaping (Map) -> Void) {
        self.controller = controller
        self.selection = selection
    }
    
    public func display(_ viewModel: MapsViewModel) {
        let freeSpaceSection = [CellController(id: UUID(), StorageCellController())]
        let mapsSection = viewModel.maps.map { viewModel in
            CellController(id: viewModel, MapCellController(model: viewModel, selection: selection))
        }
        
        controller?.display(freeSpaceSection, mapsSection)
        
    }
}

//public struct MapViewModel: Hashable {
//    public let name: String
//    
//    public init(name: String) {
//        self.name = name
//    }
//}

extension UITableView {
    func register(_ object: UITableViewCell.Type) {
        register(object, forCellReuseIdentifier: object.classString)
    }
}

public extension NSObject {
    static var classString: String {
        String(describing: self.self)
    }
}
