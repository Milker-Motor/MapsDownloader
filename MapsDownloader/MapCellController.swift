//
//  MapCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public protocol MapCellControllerDelegate {
    func didRequestMap(map: Map)
    func didCancelIMapRequest(map: Map)
}


public class MapCellController: NSObject {
    private let model: Map
    private let header: String
    private let selection: (Map) -> Void
    private let delegate: MapCellControllerDelegate
    private var cell: MapTableViewCell?
    
    public init(model: Map, header: String, delegate: MapCellControllerDelegate, selection: @escaping (Map) -> Void) {
        self.model = model
        self.header = header
        self.selection = selection
        self.delegate = delegate
    }
    
    func load() {
        delegate.didRequestMap(map: model)
    }
    
    func cancelLoad() {
        releaseCellForReuse()
//        delegate.didCancelImageRequest()
    }
}

extension MapCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MapTableViewCell.self)
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = model.name
        configuration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        
        configuration.imageProperties.tintColor = .iconMapDefault
        configuration.image = UIImage(named: model.flagImageName)
        
        cell.contentConfiguration = configuration
        cell.accessoryType = model.isMapAvailable ? .none : .disclosureIndicator
        
//        let downloadImageView = UIImageView(image: UIImage(named: "ic_custom_download"))
//        downloadImageView.tintColor = .systemBlue
//        cell.accessoryView = model.isMapAvailable ? downloadImageView : nil
        let downloadButton = UIButton(type: .custom)
        downloadButton.setImage(UIImage(named: "ic_custom_download"), for: .normal)
            
        downloadButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        downloadButton.tintColor = .systemBlue
        downloadButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.delegate.didRequestMap(map: self.model)
        }, for: .touchUpInside)

        cell.accessoryView = model.isMapAvailable ? downloadButton : nil
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .tableCellBackground
        
        backgroundConfig.backgroundColorTransformer = UIConfigurationColorTransformer { color in
            color.resolvedColor(with: UITraitCollection.current).withAlphaComponent(0.5)
        }
        
        cell.backgroundConfiguration = backgroundConfig
        self.cell = cell
        
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

extension MapCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !model.isMapAvailable {
            selection(model)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemGroupedBackground
        
        let label = UILabel()
        label.text = header
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8),
        ])
        
        return headerView
    }
}
