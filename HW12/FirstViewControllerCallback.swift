//
//  Untitled.swift
//  HW12
//
//  Created by Дарья on 07.06.2026.
//

import UIKit
import SnapKit

final class FirstViewControllerCallback: UIViewController {
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь появится результат"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let openButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Открыть второй экран", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(resultLabel)
        view.addSubview(openButton)
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().offset(-40)
        }
        
        openButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(resultLabel.snp.bottom).offset(30)
        }
        
        openButton.addAction(UIAction { [weak self] _ in
            self?.openSecondScreen()
        }, for: .touchUpInside)
    }
    
    private func openSecondScreen() {
        let secondViewController = SecondViewControllerCallback()
        
        secondViewController.onTextEntered = { [weak self] text in
            self?.resultLabel.text = text
        }
        
        navigationController?.pushViewController(secondViewController, animated: true)
    }
}
            
            
