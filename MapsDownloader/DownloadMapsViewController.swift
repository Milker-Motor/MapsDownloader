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
    
    public var tableView: UITableView {
        mapsController.tableView
    }
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
        present(alertController, animated: true)
    }
}

extension DownloadMapsViewController: MapView {
    public func display(_ viewModel: MapsViewModel) {
        mapsController.display(viewModel.maps.map { viewModel in
            CellController(id: viewModel, MapCellController(model: viewModel))
        })
    }
}

public class MapCellController: NSObject, UITableViewDataSource {
    private let model: Map
    
    public init(model: Map) {
        self.model = model
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell", for: indexPath) as! MapTableViewCell
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = model.name
        
        cell.contentConfiguration = configuration
        
        
        return cell
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
