//
//  ViewController.swift
//  HW8
//
//  Created by Дарья on 11.05.2026.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myHomeCntrlLabel: UILabel!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var passwordLable: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let registerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImageViwe = UIImageView(frame: UIScreen.main.bounds)
        bgImageViwe.image = UIImage(named: "bg")
        bgImageViwe.contentMode = .scaleAspectFill
        view.insertSubview(bgImageViwe, at: 0)
        // Do any additional setup after loading the view.
        
        myHomeCntrlLabel.text = "My Home Control"
        myHomeCntrlLabel.textColor = .white
        myHomeCntrlLabel.numberOfLines = 1
        myHomeCntrlLabel.textAlignment = .center
        myHomeCntrlLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        
        
        usernameLable.text = "Username"
        usernameLable.textColor = .white
        usernameLable.font = UIFont.systemFont(ofSize: 25)
        usernameLable.translatesAutoresizingMaskIntoConstraints = false
        usernameLable.topAnchor.constraint(equalTo: myHomeCntrlLabel.bottomAnchor, constant: 80).isActive = true
        usernameLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        passwordLable.text = "Password"
        passwordLable.textColor = .white
        passwordLable.font = UIFont.systemFont(ofSize: 25)
        passwordLable.translatesAutoresizingMaskIntoConstraints = false
        passwordLable.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 30).isActive = true
        passwordLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        logInButton.backgroundColor = .white
        logInButton.setTitleColor(.black, for: .normal)
        logInButton.setTitle("Log In", for: .normal)
        logInButton.configuration = nil
        logInButton.layer.cornerRadius = 0
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 90).isActive = true
        logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameField.attributedPlaceholder = NSAttributedString(
            string: "Please enter username",
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.4)
            ]
        )
        userNameField.borderStyle = .none
        userNameField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        userNameField.layer.cornerRadius = 5
        let usernamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 35))
        userNameField.leftView = usernamePaddingView
        userNameField.leftViewMode = .always
        userNameField.topAnchor.constraint(equalTo: usernameLable.bottomAnchor, constant: 10).isActive = true
        userNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        userNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        userNameField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        passwordField.attributedPlaceholder = NSAttributedString(
            string: "Please enter password",
            attributes: [
                .foregroundColor: UIColor.black.withAlphaComponent(0.4)
            ]
        )
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.borderStyle = .none
        passwordField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        passwordField.layer.cornerRadius = 5
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 35))
        passwordField.leftView = passwordPaddingView
        passwordField.leftViewMode = .always
        passwordField.topAnchor.constraint(equalTo: passwordLable.bottomAnchor, constant: 10).isActive = true
        passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        passwordField.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registerButton)
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
        
    }
    
    @IBAction func logInButtonTapped(_sender: UIButton) {
        print("Log In Tapped!")
    }
}




