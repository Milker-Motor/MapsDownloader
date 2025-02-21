//
//  MapCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public class MapCellController: NSObject {
    private let model: Map
    
    public init(model: Map) {
        self.model = model
    }
}

extension MapCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.classString, for: indexPath) as! MapTableViewCell
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = model.name
        configuration.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        
        configuration.imageProperties.tintColor = .iconMapDefault
        configuration.image = UIImage(named: model.flagImageName)
        
        cell.contentConfiguration = configuration
        
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .tableCellBackground
        
        backgroundConfig.backgroundColorTransformer = UIConfigurationColorTransformer { color in
            color.resolvedColor(with: UITraitCollection.current).withAlphaComponent(0.5)
        }
        
        cell.backgroundConfiguration = backgroundConfig
        
        return cell
    }
}

extension MapCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
