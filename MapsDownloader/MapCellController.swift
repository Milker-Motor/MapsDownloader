//
//  MapCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public class MapCellController: NSObject, UITableViewDataSource {
    private let model: Map
    
    public init(model: Map) {
        self.model = model
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MapTableViewCell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.classString, for: indexPath) as! MapTableViewCell
        
        var configuration = cell.defaultContentConfiguration()
        
        configuration.text = model.name
        
        cell.contentConfiguration = configuration
        
        
        return cell
    }
}
