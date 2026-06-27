//
//  ViewController.swift
//  HW14
//
//  Created by Дарья on 07.06.2026.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let devices: [String] = [
        "airpods",
        "laptopcomputer",
        "desktopcomputer",
        "appletv",
        "applewatch",
        "iphone",
        "ipad"
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
        
        collectionView.register(
            DeviceCollectionViewCell.self,
            forCellWithReuseIdentifier: DeviceCollectionViewCell.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DeviceCollectionViewCell.identifier,
            for: indexPath
        ) as? DeviceCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(name: devices[indexPath.row])
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: 80, height: 100)
    }
}
        
        
        


