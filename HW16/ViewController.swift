import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let images: [String] = [
        "image1",
        "image2",
        "image3"
    ]
    
    private var currentIndex = 0
    private var startX: CGFloat = 0
    
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(3)
        }
        
        setupImages()
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupImages() {
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: images[i])
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            
            containerView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(view)
                make.leading.equalToSuperview().offset(CGFloat(i) * view.frame.width)
            }
        }
    }
    
    @objc
    private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        
        switch gestureRecognizer.state {
        case .began:
            startX = containerView.frame.origin.x
        case .changed:
            containerView.frame.origin.x = startX + translation.x
        case .ended:
            if abs(translation.x) > 100 {
                if translation.x < 0 {
                    if currentIndex < images.count - 1 {
                        currentIndex += 1
                    }
                } else {
                    if currentIndex > 0 {
                        currentIndex -= 1
                    }
                }
            }
            
            let newX = -CGFloat(currentIndex) * view.frame.width
            
            UIView.animate(withDuration: 0.3) {
                self.containerView.frame.origin.x = newX
            }
            
        default:
            break
        }
    }
}

            
            

