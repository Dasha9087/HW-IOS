//
//  RegisterViewController.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {

    var onSuccess: (() -> Void)?
    private let presenter: AuthPresenter

    private let nameField = UITextField()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let registerButton = UIButton(type: .system)
    private let loader = UIActivityIndicatorView(style: .medium)

    init(presenter: AuthPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.view = self
        view.backgroundColor = AppColors.background
        navigationItem.title = "Регистрация"

        configure(nameField, placeholder: "Имя")
        configure(emailField, placeholder: "Email")
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none

        configure(passwordField, placeholder: "Пароль")
        passwordField.isSecureTextEntry = true

        registerButton.setTitle("Создать аккаунт", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = AppColors.orange
        registerButton.layer.cornerRadius = 12
        registerButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)

        loader.hidesWhenStopped = true

        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(registerButton)
        view.addSubview(loader)

        nameField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }

        emailField.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(nameField)
        }

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(nameField)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameField)
        }

        loader.snp.makeConstraints { make in
            make.center.equalTo(registerButton)
        }
    }

    private func configure(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.backgroundColor = .white
        field.autocorrectionType = .no
    }

    @objc private func registerTapped() {
        presenter.register(
            with: emailField.text ?? "",
            password: passwordField.text ?? "",
            name: nameField.text ?? ""
        )
    }
}

// MARK: - AuthViewInput
extension RegisterViewController: AuthViewInput {

    func showLoading(_ isLoading: Bool) {
        registerButton.isEnabled = !isLoading
        isLoading ? loader.startAnimating() : loader.stopAnimating()
    }

    func showError(with message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func didAuthorize() {
        onSuccess?()
    }
}
