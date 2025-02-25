//
//  StorageCellController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 21.02.2025.
//

import UIKit

public class StorageCellController: NSObject {
    private let cell = StorageTableViewCell()
    
    private func getDeviceStorageInfo() -> (free: Double, total: Double) {
        guard let attributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory()),
              let totalSize = attributes[.systemSize] as? NSNumber,
              let freeSize = attributes[.systemFreeSize] as? NSNumber else { return (0, 1) }
        
        let totalGB = Double(truncating: totalSize) / 1_073_741_824 // Convert bytes to GB
        let freeGB = Double(truncating: freeSize) / 1_073_741_824
        return (freeGB, totalGB)
    }
}

extension StorageCellController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let (freeSpace, totalSpace) = getDeviceStorageInfo()
        let usedPercentage = 1 - (freeSpace / totalSpace)
        
        cell.selectionStyle = .none
        cell.freeSpaceLabel.text = String(format: "Free %.2f Gb", freeSpace)
        cell.progressView.progress = Float(usedPercentage)
        
        return cell
    }
}

extension StorageCellController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }
}
