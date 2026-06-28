import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let moveStep: CGFloat = 50
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 40
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.red.cgColor
        return view
    }()
    
    private let upButton: UIButton = {
        let button = UIButton()
        button.setTitle("↑", for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private let downButton: UIButton = {
        let button = UIButton()
        button.setTitle("↓", for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("←", for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle("→", for: .normal)
        button.backgroundColor = .darkGray
        return button
    }()
    
    private var moveTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(circleView)
        view.addSubview(upButton)
        view.addSubview(downButton)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        setupConstraints()
        
        let upLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleUpLongPress(_:)))
        upLongPress.minimumPressDuration = 0
        upButton.addGestureRecognizer(upLongPress)
        
        let downLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleDownLongPress(_:)))
        downLongPress.minimumPressDuration = 0
        downButton.addGestureRecognizer(downLongPress)
        
        let leftLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLeftLongPress(_:)))
        leftLongPress.minimumPressDuration = 0
        leftButton.addGestureRecognizer(leftLongPress)
        
        let rightLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleRightLongPress(_:)))
        rightLongPress.minimumPressDuration = 0
        rightButton.addGestureRecognizer(rightLongPress)
        
        borderAnimation()
    }
    
    private func setupConstraints() {
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.center.equalToSuperview()
        }
        
        upButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.bottom.equalTo(downButton.snp.top).offset(-10)
            make.centerX.equalTo(downButton.snp.centerX)
        }
        
        downButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        leftButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.trailing.equalTo(downButton.snp.leading).offset(-10)
            make.centerY.equalTo(downButton.snp.centerY)
        }
        
        rightButton.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.leading.equalTo(downButton.snp.trailing).offset(10)
            make.centerY.equalTo(downButton.snp.centerY)
        }
    }
    
    @objc
    private func moveUp() {
        
        guard circleView.frame.minY - moveStep > 0 else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.circleView.frame.origin.y -= self.moveStep
        }
    }
    
    @objc
    private func moveDown() {
        
        let limitY = downButton.frame.minY - circleView.frame.height - 10
        
        guard circleView.frame.origin.y + moveStep <= limitY else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.circleView.frame.origin.y += self.moveStep
        }
    }
    
    @objc
    private func moveLeft() {
        
        guard circleView.frame.minX - moveStep > 0 else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.circleView.frame.origin.x -= self.moveStep
        }
    }
    
    @objc
    private func moveRight() {
        
        let maxX = view.frame.width - circleView.frame.width
        
        guard circleView.frame.origin.x + moveStep < maxX else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.circleView.frame.origin.x += self.moveStep
        }
    }
    
    @objc
    private func borderAnimation() {
        
        let animation = CABasicAnimation(keyPath: "borderColor")
        
        animation.toValue = UIColor.green.cgColor
        animation.duration = 0.5
        animation.repeatCount = .infinity
        animation.autoreverses = true
        
        circleView.layer.add(animation, forKey: "borderColor")
    }
    
    @objc
    private func handleUpLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.moveUp()
            }
        case .ended, .cancelled:
            moveTimer?.invalidate()
            moveTimer = nil
        default:
            break
        }
    }
    
    @objc
    private func handleDownLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.moveDown()
            }
        case .ended, .cancelled:
            moveTimer?.invalidate()
            moveTimer = nil
        default:
            break
        }
    }
    
    @objc
    private func handleLeftLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.moveLeft()
            }
        case .ended, .cancelled:
            moveTimer?.invalidate()
            moveTimer = nil
        default:
            break
        }
    }
    
    @objc
    private func handleRightLongPress(_ gesture: UILongPressGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                self.moveRight()
            }
        case .ended, .cancelled:
            moveTimer?.invalidate()
            moveTimer = nil
        default:
            break
        }
    }
}
            
            



