import UIKit
import SnapKit

final class FavoritesViewController: UIViewController {
    private let presenter: FavoritesPresenter
    private var ads: [Ad] = []

    private let headerEyebrowLabel = UILabel()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()
    private let headerTitleRow = UIStackView()
    private let countLabel = UILabel()

    private let tableView = UITableView()
    private let emptyStateView = UIView()
    private let emptyIconBackgroundView = UIView()
    private let emptyIconView = UIImageView()
    private let emptyTitleLabel = UILabel()
    private let emptyMessageLabel = UILabel()
    private let emptyStackView = UIStackView()

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(
        adsService: AdsServiceable = AdsService(),
        authService: AuthServiceable = AuthService()
    ) {
        self.presenter = FavoritesPresenter(
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
        title = "Избранное"

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchFavorites()
    }

    private func setupUI() {
        headerEyebrowLabel.text = "ВАША ПОДБОРКА"
        headerEyebrowLabel.font = .systemFont(ofSize: 11, weight: .bold)
        headerEyebrowLabel.textColor = AppColors.orange

        headerTitleLabel.text = "Ваши находки"
        headerTitleLabel.font = .systemFont(ofSize: 26, weight: .bold)
        headerTitleLabel.textColor = AppColors.textPrimary

        headerTitleRow.axis = .horizontal
        headerTitleRow.alignment = .center
        headerTitleRow.spacing = 10
        headerTitleRow.addArrangedSubview(headerTitleLabel)
        headerTitleRow.addArrangedSubview(countLabel)

        countLabel.text = "0"
        countLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        countLabel.textColor = AppColors.orange
        countLabel.textAlignment = .center
        countLabel.backgroundColor = AppColors.orangeLight
        countLabel.layer.cornerRadius = 14
        countLabel.clipsToBounds = true
        countLabel.setContentHuggingPriority(.required, for: .horizontal)

        headerSubtitleLabel.text = "Объявления, которые вы отметили сердцем."
        headerSubtitleLabel.font = .systemFont(ofSize: 14)
        headerSubtitleLabel.textColor = AppColors.textSecondary
        headerSubtitleLabel.numberOfLines = 0

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 130
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            AdCell.self,
            forCellReuseIdentifier: AdCell.reuseIdentifier
        )

        emptyStateView.backgroundColor = AppColors.cardBackground
        emptyStateView.layer.cornerRadius = 20
        emptyStateView.layer.borderWidth = 1
        emptyStateView.layer.borderColor = AppColors.border.cgColor
        emptyStateView.isHidden = true

        emptyIconBackgroundView.backgroundColor = AppColors.orangeLight
        emptyIconBackgroundView.layer.cornerRadius = 32
        emptyIconBackgroundView.clipsToBounds = true

        emptyIconView.image = UIImage(systemName: "heart")
        emptyIconView.tintColor = AppColors.orange
        emptyIconView.contentMode = .scaleAspectFit

        emptyTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        emptyTitleLabel.textColor = AppColors.textPrimary
        emptyTitleLabel.textAlignment = .center
        emptyTitleLabel.numberOfLines = 0

        emptyMessageLabel.font = .systemFont(ofSize: 14)
        emptyMessageLabel.textColor = AppColors.textSecondary
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.numberOfLines = 0

        emptyStackView.axis = .vertical
        emptyStackView.alignment = .center
        emptyStackView.spacing = 10

        activityIndicator.color = AppColors.orange
        activityIndicator.hidesWhenStopped = true

        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(headerEyebrowLabel)
        view.addSubview(headerTitleRow)
        view.addSubview(headerSubtitleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(activityIndicator)

        emptyStateView.addSubview(emptyStackView)
        emptyStackView.addArrangedSubview(emptyIconBackgroundView)
        emptyStackView.addArrangedSubview(emptyTitleLabel)
        emptyStackView.addArrangedSubview(emptyMessageLabel)
        emptyIconBackgroundView.addSubview(emptyIconView)

        headerEyebrowLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        headerTitleRow.snp.makeConstraints { make in
            make.top.equalTo(headerEyebrowLabel.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        countLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(36)
            make.height.equalTo(28)
        }

        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitleRow.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        emptyStateView.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalTo(tableView).inset(28)
        }

        emptyStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(18)
        }

        emptyIconBackgroundView.snp.makeConstraints { make in
            make.size.equalTo(64)
        }

        emptyIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(28)
        }

        emptyTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(emptyStateView).offset(-36)
        }

        emptyMessageLabel.snp.makeConstraints { make in
            make.width.equalTo(emptyStateView).offset(-36)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        ads.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AdCell.reuseIdentifier,
            for: indexPath
        ) as? AdCell else {
            return UITableViewCell()
        }

        cell.configure(with: ads[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard ads.indices.contains(indexPath.row) else { return }

        let ad = ads[indexPath.row]
        let detailsViewController = AdDetailsViewController(ad: ad)

        navigationController?.pushViewController(
            detailsViewController,
            animated: true
        )
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard ads.indices.contains(indexPath.row) else { return nil }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in
            self?.presenter.removeFavorite(at: indexPath.row)
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "heart.slash")
        deleteAction.backgroundColor = AppColors.orange

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - FavoritesViewInput
extension FavoritesViewController: FavoritesViewInput {
    func modelUpdated(ads: [Ad]) {
        self.ads = ads
        countLabel.text = "\(ads.count)"
        tableView.reloadData()
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showEmptyState(message: String?) {
        guard let message = message else {
            emptyStateView.isHidden = true
            return
        }

        emptyStateView.isHidden = false
        emptyMessageLabel.text = message

        if message.localizedCaseInsensitiveContains("войдите") {
            emptyTitleLabel.text = "Подборка будет ждать вас"
            emptyIconView.image = UIImage(systemName: "person.crop.circle")
        } else if message.localizedCaseInsensitiveContains("не удалось") {
            emptyTitleLabel.text = "Не получилось загрузить избранное"
            emptyIconView.image = UIImage(systemName: "exclamationmark.triangle")
        } else {
            emptyTitleLabel.text = "Пока без находок"
            emptyIconView.image = UIImage(systemName: "heart")
        }
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
