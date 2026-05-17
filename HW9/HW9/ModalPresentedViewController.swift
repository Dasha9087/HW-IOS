//
//  ModalPresentedViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit
import SnapKit

final class ModalPresentedViewController: UIViewController {

    private let label: UILabel = {
        let back = UILabel()
        back.text = "Хотите вернуться назад"
        back.font = .systemFont(ofSize: 22, weight: .bold)
        back.textAlignment = .center
        return back
    }()

    private let dismissButton: UIButton = {
        let btnBack = UIButton(type: .system)
        btnBack.setTitle("Назад", for: .normal)
        btnBack.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return btnBack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Хотите вернуться назад"

        view.addSubview(label)
        view.addSubview(dismissButton)

        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.left.right.equalToSuperview().inset(20)
        }

        dismissButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp.bottom).offset(30)
        }

        dismissButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
    }

    @objc private func dismissMe() {
        dismiss(animated: true)
    }
}
