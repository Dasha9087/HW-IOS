import UIKit
import SnapKit

class ViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
   private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private let boldButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Bold", for: .normal)
        return button
    }()
    
    private let underlineButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Underline", for: .normal)
        return button
    }()
    
    private let redButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Red", for: .normal)
        return button
    }()
    
    private let colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Color", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        boldButton.addTarget(self, action: #selector(makeBold), for: .touchUpInside)
        underlineButton.addTarget(self, action: #selector(makeUnderline), for: .touchUpInside)
        redButton.addTarget(self, action: #selector(makeRed), for: .touchUpInside)
        colorButton.addTarget(self, action: #selector(openColorPicker), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(boldButton)
        view.addSubview(underlineButton)
        view.addSubview(redButton)
        view.addSubview(colorButton)
        view.addSubview(textView)
        
        boldButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(16)
        }
        
        underlineButton.snp.makeConstraints { make in
            make.centerY.equalTo(boldButton)
            make.leading.equalTo(boldButton.snp.trailing).offset(20)
        }
        
        redButton.snp.makeConstraints { make in
            make.centerY.equalTo(boldButton)
            make.leading.equalTo(underlineButton.snp.trailing).offset(20)
        }
        
        colorButton.snp.makeConstraints { make in
            make.centerY.equalTo(boldButton)
            make.leading.equalTo(redButton.snp.trailing).offset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(boldButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc
    private func makeBold() {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        
        mutable.enumerateAttribute(.font, in: selectedRange, options: []) { value, range, _ in
            let currentFont = (value as? UIFont) ?? UIFont.systemFont(ofSize: 18)
            
            if currentFont.fontDescriptor.symbolicTraits.contains(.traitBold) {
                let newFont = UIFont.systemFont(ofSize: currentFont.pointSize)
                mutable.addAttribute(.font, value: newFont, range: range)
            } else {
                let newFont = UIFont.boldSystemFont(ofSize: currentFont.pointSize)
                mutable.addAttribute(.font, value: newFont, range: range)
            }
        }
        
        textView.attributedText = mutable
        textView.selectedRange = selectedRange
    }
    
    @objc
    private func makeUnderline() {
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        
        mutable.enumerateAttribute(.underlineStyle, in: selectedRange, options: []) { value, range, _ in
            if value != nil {
                mutable.removeAttribute(.underlineStyle, range: range)
            } else {
                mutable.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        
        textView.attributedText = mutable
        textView.selectedRange = selectedRange
    }
    
    @objc
    private func makeRed() {
        applyAttribute(.foregroundColor, value: UIColor.red)
    }
    
    @objc
    private func openColorPicker() {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            applyAttribute(.foregroundColor, value: viewController.selectedColor)
        }
    
    private func applyAttribute(_ key: NSAttributedString.Key, value: Any) {
        
        let selectedRange = textView.selectedRange
        guard selectedRange.length > 0 else { return }
        
        let mutable = NSMutableAttributedString(attributedString: textView.attributedText)
        
        mutable.enumerateAttributes(in: selectedRange, options: []) { attributes, range, _ in
            if attributes[key] != nil {
                mutable.removeAttribute(key, range: range)
            } else {
                mutable.addAttribute(key, value: value, range: range)
            }
        }
        
        textView.attributedText = mutable
        textView.selectedRange = selectedRange
    }
}
