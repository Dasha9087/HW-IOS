//
//  AdCell.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit
import SnapKit

final class AdCell: UITableViewCell {

    static let reuseIdentifier = "AdCell"

    private let card = UIView()
    private let iconBackgroundView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let metaLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with ad: Ad) {
        titleLabel.text = ad.title
        priceLabel.text = AdFormatter.price(ad.price)
        metaLabel.text = "\(ad.city) · \(ad.category) · \(AdFormatter.date(ad.createdAt))"

        let iconName = AdCategory(rawValue: ad.category)?.iconName ?? "car.fill"
        iconView.image = ImageCache.shared.image(named: iconName)
    }
}

private extension AdCell {

    func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        card.backgroundColor = AppColors.cardBackground
        card.layer.cornerRadius = 18
        card.layer.borderWidth = 1
        card.layer.borderColor = AppColors.border.cgColor

        iconBackgroundView.backgroundColor = AppColors.orangeLight
        iconBackgroundView.layer.cornerRadius = 16
        iconBackgroundView.clipsToBounds = true

        iconView.tintColor = AppColors.orange
        iconView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.numberOfLines = 2

        priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
        priceLabel.textColor = AppColors.orange

        metaLabel.font = .systemFont(ofSize: 13, weight: .regular)
        metaLabel.textColor = AppColors.textSecondary
        metaLabel.numberOfLines = 2

        contentView.addSubview(card)
        card.addSubview(iconBackgroundView)
        iconBackgroundView.addSubview(iconView)
        card.addSubview(titleLabel)
        card.addSubview(priceLabel)
        card.addSubview(metaLabel)

        card.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 7, left: 16, bottom: 7, right: 16)
            )
        }

        iconBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(58)
        }

        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(iconBackgroundView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(14)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(titleLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(14)
        }

        metaLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(14)
        }
    }
}
