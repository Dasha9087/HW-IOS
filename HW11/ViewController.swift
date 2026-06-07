//
//  ViewController.swift
//  HW11
//
//  Created by Дарья on 23.05.2026.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private var headerContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private var displayContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private var headerSpacerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private var historyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1).cgColor
        button.tintColor = .white
        
        let image = UIImage(
            systemName: "clock",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private var modeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 24/255, green: 24/255, blue: 24/255, alpha: 1)
        button.layer.cornerRadius = 28
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1).cgColor
        button.tintColor = .white
        
        let image = UIImage(named: "calculate")
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        return button
    }()
    
    private var operationLabel: UILabel = {
        let label = UILabel()
        label.text = "75-20"
        label.textColor = UIColor.white.withAlphaComponent(0.55)
        label.font = .systemFont(ofSize: 32, weight: .regular)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "55"
        label.textColor = .white
        label.font = .systemFont(ofSize: 92, weight: .light)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private var buttonsContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private var buttonsStackView = ButtonStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureButtons()
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(contentView)
        
        contentView.addSubview(headerContainer)
        contentView.addSubview(displayContainer)
        contentView.addSubview(buttonsContainer)
        
        headerContainer.addSubview(headerStackView)
        displayContainer.addSubview(operationLabel)
        displayContainer.addSubview(resultLabel)
        buttonsContainer.addSubview(buttonsStackView)
        
        headerStackView.addArrangedSubview(historyButton)
        headerStackView.addArrangedSubview(headerSpacerView)
        headerStackView.addArrangedSubview(modeButton)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        headerContainer.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
        headerStackView.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.top)
            make.leading.equalTo(headerContainer.snp.leading)
            make.trailing.equalTo(headerContainer.snp.trailing)
            make.bottom.equalTo(headerContainer.snp.bottom)
        }
        historyButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        modeButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.width.equalTo(56)
        }
        buttonsContainer.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(12)
            make.height.equalTo(buttonsContainer.snp.width).multipliedBy(1.26)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(buttonsContainer.snp.top)
            make.leading.equalTo(buttonsContainer.snp.leading)
            make.trailing.equalTo(buttonsContainer.snp.trailing)
            make.bottom.equalTo(buttonsContainer.snp.bottom)
        }
        displayContainer.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
            make.bottom.equalTo(buttonsContainer.snp.top).offset(-20)
        }
        resultLabel.snp.makeConstraints { make in
            make.trailing.equalTo(displayContainer.snp.trailing)
            make.bottom.equalTo(displayContainer.snp.bottom)
            make.leading.greaterThanOrEqualTo(displayContainer.snp.leading)
        }
        operationLabel.snp.makeConstraints { make in
            make.trailing.equalTo(displayContainer.snp.trailing)
            make.bottom.equalTo(resultLabel.snp.top).offset(-8)
            make.leading.greaterThanOrEqualTo(displayContainer.snp.leading)
        }
    }
    
    func configureButtons() {
        let buttons: [[CalculatorButtonItem]] = [
            [CalculatorButtonItem(imageName: "delete.left", style: .action),
             CalculatorButtonItem(title: "AC", style: .action),
             CalculatorButtonItem(title: "%", style: .action),
             CalculatorButtonItem(title: "÷", style: .operation)],
            [CalculatorButtonItem(title: "7", style: .number),
             CalculatorButtonItem(title: "8", style: .number),
             CalculatorButtonItem(title: "9", style: .number),
             CalculatorButtonItem(title: "×", style: .operation)],
            [CalculatorButtonItem(title: "4", style: .number),
             CalculatorButtonItem(title: "5", style: .number),
             CalculatorButtonItem(title: "6", style: .number),
             CalculatorButtonItem(title: "−", style: .operation)],
            [CalculatorButtonItem(title: "1", style: .number),
             CalculatorButtonItem(title: "2", style: .number),
             CalculatorButtonItem(title: "3", style: .number),
             CalculatorButtonItem(title: "+", style: .operation)],
            [CalculatorButtonItem(title: "+/-", style: .number),
             CalculatorButtonItem(title: "0", style: .number),
             CalculatorButtonItem(title: ",", style: .number),
             CalculatorButtonItem(title: "=", style: .operation)]
        ]
        
        buttonsStackView.configure(buttons: buttons)
    }
}

struct CalculatorButtonItem {
    let title: String?
    let imageName: String?
    let style: CustomButtonStyle
    
    init(title: String, style: CustomButtonStyle) {
        self.title = title
        self.imageName = nil
        self.style = style
    }
    
    init(imageName: String, style: CustomButtonStyle) {
        self.title = nil
        self.imageName = imageName
        self.style = style
    }
}

enum CustomButtonStyle {
    case number
    case action
    case operation
    
    var backgroundColor: UIColor {
        switch self {
        case .number:
            return UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)
        case .action:
            return UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        case .operation:
            return UIColor(red: 255/255, green: 159/255, blue: 10/255, alpha: 1)
        }
    }
    var textColor: UIColor {
        return .white
    }
}

final class ButtonStackView: UIView {
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
    func configure(buttons: [[CalculatorButtonItem]]) {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for row in buttons {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 12
            
            stackView.addArrangedSubview(rowStackView)
            
            for item in row {
                let button = CustomButton(style: item.style)
                button.configure(with: item)
                rowStackView.addArrangedSubview(button)
            }
        }
    }
}

final class CustomButton: UIButton {
    private let style: CustomButtonStyle
    
    init(style: CustomButtonStyle) {
        self.style = style
        super.init(frame: .zero)
        setupCustomButton()
    }
    
    override init(frame: CGRect) {
        self.style = .number
        super.init(frame: frame)
        setupCustomButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupCustomButton() {
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        tintColor = style.textColor
        titleLabel?.font = .systemFont(ofSize: 34, weight: .regular)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
        clipsToBounds = true
        
        setTitleColor(style.textColor.withAlphaComponent(0.6), for: .highlighted)
    }
    
    func configure(with item: CalculatorButtonItem) {
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        
        if let title = item.title {
            setTitle(title, for: .normal)
        }
        if let imageName = item.imageName {
            let image = UIImage(
                systemName: imageName,
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
            )
            setImage(image, for: .normal)
        }
    }
}







