//
//  PushTab2NextViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit

final class PushTab2NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        title = "Pushed 2"

        let labelClose = UILabel()
        labelClose.text = "Закройте!"
        labelClose.font = .systemFont(ofSize: 20, weight: .bold)
        labelClose.textAlignment = .center

        view.addSubview(labelClose)
        labelClose.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelClose.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelClose.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
