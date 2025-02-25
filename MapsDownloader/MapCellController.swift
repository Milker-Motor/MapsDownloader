//
//  MapCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public protocol MapCellControllerDelegate {
    func didRequestMap(map: Map, progress: @escaping (Progress) -> Void)
    func didCancelIMapRequest(map: Map)
}

public class MapCellController: NSObject {
    private let model: Map
    private let header: String
    private let selection: (Map) -> Void
    private let delegate: MapCellControllerDelegate
    private var cell: MapTableViewCell?
    private var cellState: MapTableViewCell.State
    
    public init(model: Map, header: String, delegate: MapCellControllerDelegate, selection: @escaping (Map) -> Void) {
        self.model = model
        self.header = header
        self.selection = selection
        self.delegate = delegate
        self.cellState = model.isMapAvailable ? .notRun : .default
    }
    
    private func load() {
        cellState = .downloading
        delegate.didRequestMap(map: model) { [weak cell] progress in
            DispatchQueue.main.async {
                cell?.progressView.progress = Float(progress.fractionCompleted)
                UIView.animate(withDuration: 0.2) {
                    
                    cell?.layoutIfNeeded()
                }
                
                cell?.state = .downloading
            }
        }
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelIMapRequest(map: model)
        cellState = .notRun
//        delegate.didCancelImageRequest()
    }
}

extension MapCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MapTableViewCell.self)
        
        cell.state = cellState
        
        cell.actionButton.addAction(UIAction { [weak self] _ in
            self?.load()
        }, for: .touchUpInside)
        
        cell.nameLabel.text = model.name
        self.cell = cell
        
        return cell
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

//private extension Map {
//    var cellState: MapTableViewCell.State {
//        
//    }
//}

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
