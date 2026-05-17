//
//  ModalTabViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit
import SnapKit

final class ModalTabViewController: UIViewController {

    private let button: UIButton = {
        let btnGo = UIButton(type: .system)
        btnGo.setTitle("Перейти", for: .normal)
        btnGo.backgroundColor = .white
        btnGo.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        btnGo.layer.cornerRadius = 14
        btnGo.contentEdgeInsets = UIEdgeInsets(top: 16, left: 28, bottom: 16, right: 28)
        return btnGo
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        title = "Modal"

        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        button.addTarget(self, action: #selector(openModal), for: .touchUpInside)
    }

    @objc private func openModal() {
        let vc = ModalPresentedViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
