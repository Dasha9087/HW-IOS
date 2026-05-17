//
//  PushTab1RootViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit
import SnapKit

final class PushTab1RootViewController: UIViewController {

    private let button: UIButton = {
        let btnSee = UIButton(type: .system)
        btnSee.setTitle("Посмотреть", for: .normal)
        btnSee.setTitleColor(.white, for: .normal)
        btnSee.backgroundColor = .red
        btnSee.layer.cornerRadius = 30
        btnSee.contentEdgeInsets = UIEdgeInsets(top: 25, left: 58, bottom: 25, right: 58)
        btnSee.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btnSee
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        title = "Push 1"

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        button.addTarget(self, action: #selector(goNext), for: .touchUpInside)
    }

    @objc private func goNext() {
        navigationController?.pushViewController(PushTab1NextViewController(), animated: true)
    }
}
