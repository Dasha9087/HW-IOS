//
//  ThirdViewController.swift
//  HW8
//
//  Created by Дарья on 16.05.2026.
//

import UIKit

class ThirdViewController: UIViewController {

    let backgroundImageView = UIImageView()

    let titleLabel = UILabel()

    let usernameLabel = UILabel()
    let usernameField = UITextField()

    let passwordLabel = UILabel()
    let passwordField = UITextField()

    let confirmPasswordLabel = UILabel()
    let confirmPasswordField = UITextField()

    let saveButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupTitle()
        setupUsername()
        setupPassword()
        setupConfirmPassword()
        setupSaveButton()
    }

    func setupBackground() {
        backgroundImageView.image = UIImage(named: "registrationBackground")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Если картинки нет, будет просто цвет фона
        view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.5)
    }

    func setupTitle() {
        titleLabel.text = "Registration Form"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 31, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
        ])
    }

    func setupUsername() {
        usernameLabel.text = "Username"
        usernameLabel.textColor = .white
        usernameLabel.font = UIFont.systemFont(ofSize: 20)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(usernameLabel)

        setupTextField(usernameField, placeholder: "Please enter username")

        view.addSubview(usernameField)

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),

            usernameField.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            usernameField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    func setupPassword() {
        passwordLabel.text = "Password"
        passwordLabel.textColor = .white
        passwordLabel.font = UIFont.systemFont(ofSize: 20)
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(passwordLabel)

        setupTextField(passwordField, placeholder: "Please enter password")
        passwordField.isSecureTextEntry = true

        view.addSubview(passwordField)

        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 25),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),

            passwordField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            passwordField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    func setupConfirmPassword() {
        confirmPasswordLabel.text = "Confirm password"
        confirmPasswordLabel.textColor = .white
        confirmPasswordLabel.font = UIFont.systemFont(ofSize: 20)
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(confirmPasswordLabel)

        setupTextField(confirmPasswordField, placeholder: "Please confirm password")
        confirmPasswordField.isSecureTextEntry = true

        view.addSubview(confirmPasswordField)

        NSLayoutConstraint.activate([
            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 25),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),

            confirmPasswordField.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 10),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 55),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -55),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }

    func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(saveButton)

        saveButton.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside
        )

        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 110),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        textField.textColor = UIColor.black.withAlphaComponent(0.7)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.35)
            ]
        )

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 35))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }

    @objc func saveButtonTapped() {
        print("Save tapped")
    }
}
