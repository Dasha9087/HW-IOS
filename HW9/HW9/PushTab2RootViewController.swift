//
//  PushTab2RootViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit
import SnapKit

final class PushTab2RootViewController: UIViewController {

    private let button: UIButton = {
        let btnOpen = UIButton(type: .system)
        btnOpen.setTitle("Открыть", for: .normal)
        btnOpen.titleLabel?.font = .systemFont(ofSize: 30, weight: .semibold)
        btnOpen.setTitleColor(.white, for: .normal)
        return btnOpen
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
        title = "Push 2"

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }

    @objc private func goNext() {
        navigationController?.pushViewController(PushTab2NextViewController(), animated: true)
    }
}
