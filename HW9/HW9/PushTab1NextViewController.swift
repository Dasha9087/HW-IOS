//
//  PushTab1NextViewController.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit
import SnapKit

final class PushTab1NextViewController: UIViewController {
    
    private let imageView: UIImageView = {
           let iv = UIImageView()
           iv.image = UIImage(named: "Cat")
           iv.contentMode = .scaleAspectFit
           iv.clipsToBounds = true
           return iv
       }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = "Pushed 1"
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(120)
         make.width.height.equalTo(550)
}
}
}
