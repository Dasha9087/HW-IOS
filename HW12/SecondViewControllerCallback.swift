//
//  SecondViewControllerCallback.swift
//  HW12
//
//  Created by Дарья on 07.06.2026.
//

import UIKit
import SnapKit

final class SecondViewControllerCallback: UIViewController {
    
    var onTextEntered: ((String) -> Void)?
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите текст"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Передать на первый экран", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(30)
        }
        
        sendButton.addAction(UIAction { [weak self] _ in
            self?.sendText()
            }, for: .touchUpInside)
    }
    
    private func sendText() {
        let enteredText = textField.text ?? "Нет текста"
        onTextEntered?(enteredText)
        navigationController?.popViewController(animated: true)
    }
}

