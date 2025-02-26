//
//  MapCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public protocol MapCellControllerDelegate {
    func didRequestMap(cellModel: MapCellModel, progress: @escaping (Progress) -> Void, completion: @escaping(Error?) -> Void)
    func didCancelIMapRequest(model: MapCellModel)
}

public struct MapCellModel {
    let name: String
    let parent: String?
    let isMapAvailable: Bool
}

public class MapCellController: NSObject {
    private let model: MapCellModel
    private let header: String
    private let selection: (MapCellModel) -> Void
    private let delegate: MapCellControllerDelegate
    private var cell: MapTableViewCell?
    
    private var state: MapTableViewCell.State {
        didSet {
            cell?.onState?(state)
        }
    }
    
    private var onProgress: ((Progress) -> Void)?
    
    public init(model: MapCellModel, header: String, delegate: MapCellControllerDelegate, selection: @escaping (MapCellModel) -> Void) {
        
        self.model = model
        self.header = header
        self.selection = selection
        self.delegate = delegate
        self.state = model.isMapAvailable ? .notRun : .default
        super.init()
        
        self.onProgress = { [weak self] progress in
            self?.cell?.progressView.progress = Float(progress.fractionCompleted)
            UIView.animate(withDuration: 0.2) {
                self?.cell?.layoutIfNeeded()
            }
        }
    }
    
    private func load() {
        state = .downloading
        delegate.didRequestMap(cellModel: model, progress: { [weak self] progress in
            DispatchQueue.main.async {
                self?.onProgress?(progress)
            }
        }, completion: { [weak self] error in
            DispatchQueue.main.async {
                self?.state = error == nil ? .downloaded : .notRun
            }
        })
    }
    
    func cancelLoad() {
        state = .notRun
        delegate.didCancelIMapRequest(model: model)
        
    }
}

extension MapCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(MapTableViewCell.self)
        
        cell.nameLabel.text = model.name
        cell.onState?(state)
        
        cell.actionButton.removeTarget(nil, action: nil, for: .touchUpInside)
        
        cell.actionButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            if self.state == .downloading {
                self.cancelLoad()
            } else {
                self.load()
            }
        }, for: .touchUpInside)
         
        self.cell = cell
        
        return cell
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
