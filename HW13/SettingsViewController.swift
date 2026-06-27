//
//  SettingsViewController.swift
//  HW13
//
//  Created by Дарья on 07.06.2026.
//

import UIKit
import SnapKit

struct SettingItem {
    let title: String
    let icon: String
    let color: UIColor
}

final class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let sections: [[SettingItem]] = [
        [
            SettingItem(title: "Фокусирование", icon: "moon.fill", color: .systemIndigo),
            SettingItem(title: "Экранное время", icon: "hourglass", color: .systemPurple)
        ],
        [
            SettingItem(title: "Face ID и код-пароль", icon: "faceid", color: .systemGreen),
            SettingItem(title: "Экстренный вызов — SOS", icon: "sos", color: .systemRed),
            SettingItem(title: "Конфиденциальность и безопасность", icon: "hand.raised.fill", color: .systemBlue)
        ],
        [
            SettingItem(title: "Game Center", icon: "gamecontroller.fill", color: .systemGreen),
            SettingItem(title: "iCloud", icon: "icloud.fill", color: .systemCyan),
            SettingItem(title: "Wallet и Apple Pay", icon: "creditcard.fill", color: .systemOrange)
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Настройки"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsCell.identifier,
            for: indexPath
        ) as? SettingsCell else {
            return UITableViewCell()
        }
        
        let item = sections[indexPath.section]
        let setting = item[indexPath.row]
        
        cell.configure(
            title: setting.title,
            systemImage: setting.icon,
            backgroundColor: setting.color
        )
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
}

            
            
            
