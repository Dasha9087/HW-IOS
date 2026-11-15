//
//  LoginViewController.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    var onSuccess: (() -> Void)?
    private let presenter: AuthPresenter

    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
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
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.background
        navigationItem.title = "Вход"
        navigationController?.navigationBar.tintColor = AppColors.orange

        titleLabel.text = "av.by"
        titleLabel.font = .systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textColor = AppColors.orange
        titleLabel.textAlignment = .center

        configure(emailField, placeholder: "Email")
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none

        configure(passwordField, placeholder: "Пароль")
        passwordField.isSecureTextEntry = true

        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = AppColors.orange
        loginButton.layer.cornerRadius = 12
        loginButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        registerButton.setTitle("Нет аккаунта? Регистрация", for: .normal)
        registerButton.setTitleColor(AppColors.orange, for: .normal)
        registerButton.addTarget(self, action: #selector(openRegister), for: .touchUpInside)

        loader.hidesWhenStopped = true

        view.addSubview(titleLabel)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(loader)

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(48)
            make.leading.trailing.equalToSuperview().inset(24)
        }

        emailField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(emailField)
        }

        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(emailField)
            make.height.equalTo(48)
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        loader.snp.makeConstraints { make in
            make.center.equalTo(loginButton)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func configure(_ field: UITextField, placeholder: String) {
        field.placeholder = placeholder
        field.borderStyle = .roundedRect
        field.backgroundColor = .white
        field.autocorrectionType = .no
    }

    @objc private func loginTapped() {
        presenter.login(
            with: emailField.text ?? "",
            password: passwordField.text ?? ""
        )
    }

    @objc private func openRegister() {
        let presenter = AuthPresenter(
            auth: AuthService(),
            storage: StorageService.shared
        )
        let controller = RegisterViewController(presenter: presenter)
        controller.onSuccess = onSuccess
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - AuthViewInput
extension LoginViewController: AuthViewInput {

    func showLoading(_ isLoading: Bool) {
        loginButton.isEnabled = !isLoading
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
