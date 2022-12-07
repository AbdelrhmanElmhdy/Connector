//
//  SettingsCustomizationTableViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 06/12/2022.
//

import Foundation
import UIKit

fileprivate let settingsCustomizationCellReuseIdentifier = "settingsCustomizationCellReuseIdentifier"

class SettingsCustomizationTableViewController: UITableViewController {
    // MARK: Properties
    
    unowned var coordinator: Coordinator
    
    // MARK: Initialization
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCustomizationCellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
            
    // MARK: Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.setEmptyMessage("This screen is yet to be implemented".localized)
        tableView.isScrollEnabled = false
        return 0
    }
}
