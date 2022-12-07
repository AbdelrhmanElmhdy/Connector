//
//  SettingsViewController.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 08/06/2022.
//

import UIKit
import FirebaseAuth

fileprivate let settingsCellReuseIdentifier = "settingsCellReuseIdentifier"

class SettingsViewController: UITableViewController {
    // MARK: Properties
    
    typealias CoordinatorFunctionality = LoggingOut & CustomizingGeneralSettings & CustomizingAccountSettings & CustomizingNotificationsSettings & CustomizingSoundsAndHapticsSettings
    
    unowned var coordinator: CoordinatorFunctionality
    
    let viewModel: SettingsViewModel
    
    lazy var settingsTableViewCellModels: [[SettingsTableViewCellModel]] = [
        [
            SettingsTableViewCellModel(icon: UIImage(named: "GeneralSettingsIcon"),
                                       label: "General".localized) { [weak self] in
                self?.didTabGeneral()
            },

            SettingsTableViewCellModel(icon: UIImage(named: "AccountIcon"),
                                       label: "Account".localized) { [weak self] in
                self?.didTabAccount()
            },

            SettingsTableViewCellModel(icon: UIImage(named: "NotificationsIcon"),
                                       label: "Notifications".localized) { [weak self] in
                self?.didTabNotifications()
            },

            SettingsTableViewCellModel(icon: UIImage(named: "SoundsIcon"),
                                       label: "Sounds & Haptics".localized) { [weak self] in
                self?.didTabSoundAndHaptics()
            }
        ],
        [
            SettingsTableViewCellModel(icon: nil, label: "Logout".localized) { [weak self] in
                self?.didTabLogout()
            }
        ]
    ]
    
    // MARK: Initialization
        
    init(coordinator: CoordinatorFunctionality, viewModel: SettingsViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        title = "Settings"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingsCellReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    // MARK: Convenience
    
    func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: Data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsTableViewCellModels.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTableViewCellModels[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingsCellReuseIdentifier, for: indexPath)
        let cellModel = settingsTableViewCellModels[indexPath.section][indexPath.row]
        var contentConfiguration = UIListContentConfiguration.cell()
        
        contentConfiguration.text = cellModel.label
        
        if indexPath.section == 0 {
            contentConfiguration.image = cellModel.icon
            cell.accessoryType = .disclosureIndicator
        } else {
            contentConfiguration.textProperties.alignment = .center
            contentConfiguration.textProperties.color = .systemRed
        }
        
        cell.contentConfiguration = contentConfiguration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = settingsTableViewCellModels[indexPath.section][indexPath.row]
        cellModel.tabHandler()
    }
    
}
