import UIKit
import SnapKit

final class AdDetailsViewController: UIViewController {

    private let presenter: AdDetailsPresenter

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentStackView = UIStackView()

    private let vehicleCard = UIView()
    private let vehicleContentStackView = UIStackView()
    private let vehicleIconContainer = UIView()
    private let vehicleIconView = UIImageView()
    private let vehicleInfoStackView = UIStackView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()

    private let detailsCard = UIView()
    private let detailsStackView = UIStackView()
    private let detailsTitleLabel = UILabel()
    private let categoryRow = UIStackView()
    private let categoryIconView = UIImageView()
    private let categoryLabel = UILabel()
    private let detailsSeparator = UIView()
    private let cityRow = UIStackView()
    private let cityIconView = UIImageView()
    private let cityLabel = UILabel()

    private let descriptionCard = UIView()
    private let descriptionStackView = UIStackView()
    private let descriptionTitleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateRow = UIStackView()
    private let dateIconView = UIImageView()
    private let dateLabel = UILabel()

    private lazy var favoriteButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
    }()

    init(
        ad: Ad,
        adsService: AdsServiceable = AdsService(),
        authService: AuthServiceable = AuthService()
    ) {
        self.presenter = AdDetailsPresenter(
            ad: ad,
            adsService: adsService,
            authService: authService
        )

        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.catalogBackground
        title = "Объявление"
        navigationItem.rightBarButtonItem = favoriteButton

        setupVehicleCard()
        setupDetailsCard()
        setupDescriptionCard()
        setupLayout()

        presenter.fetchAd()
    }

    private func setupVehicleCard() {
        setupCard(vehicleCard)

        vehicleIconContainer.backgroundColor = AppColors.orangeLight
        vehicleIconContainer.layer.cornerRadius = 20

        vehicleIconView.image = UIImage(systemName: "car.fill")
        vehicleIconView.tintColor = AppColors.orange
        vehicleIconView.contentMode = .scaleAspectFit

        vehicleIconContainer.addSubview(vehicleIconView)
        vehicleIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(34)
        }

        titleLabel.font = .systemFont(ofSize: 23, weight: .bold)
        titleLabel.textColor = AppColors.textPrimary
        titleLabel.numberOfLines = 0

        priceLabel.font = .systemFont(ofSize: 23, weight: .bold)
        priceLabel.textColor = AppColors.orange
        priceLabel.numberOfLines = 1

        vehicleInfoStackView.axis = .vertical
        vehicleInfoStackView.alignment = .leading
        vehicleInfoStackView.spacing = 7
        vehicleInfoStackView.addArrangedSubview(titleLabel)
        vehicleInfoStackView.addArrangedSubview(priceLabel)

        vehicleContentStackView.axis = .horizontal
        vehicleContentStackView.alignment = .center
        vehicleContentStackView.spacing = 16
        vehicleContentStackView.addArrangedSubview(vehicleIconContainer)
        vehicleContentStackView.addArrangedSubview(vehicleInfoStackView)

        vehicleCard.addSubview(vehicleContentStackView)

        vehicleIconContainer.snp.makeConstraints { make in
            make.size.equalTo(68)
        }

        vehicleContentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }
    }

    private func setupDetailsCard() {
        setupCard(detailsCard)

        detailsTitleLabel.text = "Информация"
        detailsTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        detailsTitleLabel.textColor = AppColors.textPrimary

        setupRow(
            categoryRow,
            iconView: categoryIconView,
            systemName: "square.grid.2x2.fill",
            label: categoryLabel
        )

        setupRow(
            cityRow,
            iconView: cityIconView,
            systemName: "mappin.and.ellipse",
            label: cityLabel
        )

        categoryLabel.font = .systemFont(ofSize: 15, weight: .medium)
        categoryLabel.textColor = AppColors.textPrimary
        categoryLabel.numberOfLines = 0

        cityLabel.font = .systemFont(ofSize: 15, weight: .medium)
        cityLabel.textColor = AppColors.textPrimary
        cityLabel.numberOfLines = 0

        detailsSeparator.backgroundColor = AppColors.border

        detailsStackView.axis = .vertical
        detailsStackView.alignment = .fill
        detailsStackView.spacing = 14

        detailsStackView.addArrangedSubview(detailsTitleLabel)
        detailsStackView.addArrangedSubview(categoryRow)
        detailsStackView.addArrangedSubview(detailsSeparator)
        detailsStackView.addArrangedSubview(cityRow)

        detailsCard.addSubview(detailsStackView)

        detailsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }

        detailsSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }

    private func setupDescriptionCard() {
        setupCard(descriptionCard)

        descriptionTitleLabel.text = "Описание"
        descriptionTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textColor = AppColors.textPrimary

        descriptionLabel.font = .systemFont(ofSize: 15)
        descriptionLabel.textColor = AppColors.textSecondary
        descriptionLabel.numberOfLines = 0

        dateIconView.image = UIImage(systemName: "calendar")
        dateIconView.tintColor = AppColors.orange
        dateIconView.contentMode = .scaleAspectFit

        dateLabel.font = .systemFont(ofSize: 13)
        dateLabel.textColor = AppColors.textSecondary
        dateLabel.numberOfLines = 0

        dateRow.axis = .horizontal
        dateRow.alignment = .center
        dateRow.spacing = 8
        dateRow.addArrangedSubview(dateIconView)
        dateRow.addArrangedSubview(dateLabel)

        dateIconView.snp.makeConstraints { make in
            make.size.equalTo(16)
        }

        descriptionStackView.axis = .vertical
        descriptionStackView.alignment = .fill
        descriptionStackView.spacing = 12
        descriptionStackView.addArrangedSubview(descriptionTitleLabel)
        descriptionStackView.addArrangedSubview(descriptionLabel)
        descriptionStackView.addArrangedSubview(dateRow)

        descriptionCard.addSubview(descriptionStackView)

        descriptionStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }
    }

    private func setupRow(
        _ row: UIStackView,
        iconView: UIImageView,
        systemName: String,
        label: UILabel
    ) {
        iconView.image = UIImage(systemName: systemName)
        iconView.tintColor = AppColors.orange
        iconView.contentMode = .scaleAspectFit

        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 12
        row.addArrangedSubview(iconView)
        row.addArrangedSubview(label)

        iconView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
    }

    private func setupCard(_ card: UIView) {
        card.backgroundColor = AppColors.cardBackground
        card.layer.cornerRadius = 22
        card.layer.borderWidth = 1
        card.layer.borderColor = AppColors.border.cgColor
    }

    private func setupLayout() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .clear

        contentView.backgroundColor = .clear

        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.spacing = 14

        contentStackView.addArrangedSubview(vehicleCard)
        contentStackView.addArrangedSubview(detailsCard)
        contentStackView.addArrangedSubview(descriptionCard)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            )
        }
    }

    @objc private func favoriteButtonTapped() {
        presenter.favoriteButtonTapped()
    }
}

// MARK: - AdDetailsViewInput

extension AdDetailsViewController: AdDetailsViewInput {

    func modelUpdated(model: AdDetailsViewModel) {
        titleLabel.text = model.title
        priceLabel.text = model.price
        categoryLabel.text = "Категория: \(model.category)"
        cityLabel.text = "Город: \(model.city)"

        if model.descriptionText.isEmpty {
            descriptionLabel.text = "Описание не указано."
        } else {
            descriptionLabel.text = model.descriptionText
        }

        dateLabel.text = model.dateText
    }

    func setFavoriteButton(isFavorite: Bool, isEnabled: Bool) {
        favoriteButton.image = UIImage(
            systemName: isFavorite ? "heart.fill" : "heart"
        )
        favoriteButton.tintColor = AppColors.orange
        favoriteButton.isEnabled = isEnabled
    }

    func showError(with message: String) {
        let alert = UIAlertController(
            title: "Информация",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
