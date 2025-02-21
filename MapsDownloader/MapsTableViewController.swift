//
//  MapsTableViewController.swift
//  MapsDownloader
//
//  Created by Oleksii Lytvynov-Bohdanov on 20.02.2025.
//

import UIKit

class MapsTableViewController: UITableViewController {
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.dataSource.tableView(tableView, cellForRowAt: index)
        }
    }()
    
    init() {
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = .tableSeparator
    }
    
    func display(_ sections: [CellController]...) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        sections.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems(cellControllers, toSection: section)
        }
        
        dataSource.applySnapshotUsingReloadData(snapshot)
    }
    
    private func cellController(at indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
}

extension MapsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dg = cellController(at: indexPath)?.delegate
        dg?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let dg = cellController(at: IndexPath(row: 0, section: section))?.delegate
        return dg?.tableView?(tableView, heightForHeaderInSection: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dg = cellController(at: IndexPath(row: 0, section: section))?.delegate
        return dg?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let ds = cellController(at: IndexPath(row: 0, section: section))?.dataSource
        return ds?.tableView?(tableView, titleForHeaderInSection: section)
    }
}
