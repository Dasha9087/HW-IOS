import UIKit
import SnapKit

final class ProfileViewController: UIViewController, ProfileViewInput {

    var presenter: ProfileViewHandler?
    var onLogout: (() -> Void)?

    private var ads: [Ad] = []
    private var emptyMessage: String?

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = UIView()

    private let profileCard = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let signOutButton = UIButton(type: .system)

    private let adsHeaderView = UIView()
    private let adsTitleLabel = UILabel()
    private let adsCountLabel = UILabel()

    private let emptyView = UIView()
    private let emptyCard = UIView()
    private let emptyIconView = UIImageView()
    private let emptyTitleLabel = UILabel()
    private let emptyMessageLabel = UILabel()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.catalogBackground
        title = "Профиль"

        setupTableView()
        setupHeaderView()
        setupEmptyView()
        setupActivityIndicator()

        presenter?.fetchUser()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderHeight()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 16,
            right: 0
        )

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            AdCell.self,
            forCellReuseIdentifier: AdCell.reuseIdentifier
        )

        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 1
        )

        tableView.tableHeaderView = headerView
    }

    private func setupHeaderView() {
        headerView.backgroundColor = .clear
        headerView.addSubview(profileCard)
        headerView.addSubview(adsHeaderView)

        setupProfileCard()
        setupAdsHeader()

        profileCard.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        adsHeaderView.snp.makeConstraints { make in
            make.top.equalTo(profileCard.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-12)
        }
    }

    private func setupProfileCard() {
        profileCard.backgroundColor = AppColors.cardBackground
        profileCard.layer.cornerRadius = 22
        profileCard.layer.borderWidth = 1
        profileCard.layer.borderColor = AppColors.border.cgColor

        profileCard.addSubview(avatarLabel)
        profileCard.addSubview(nameLabel)
        profileCard.addSubview(emailLabel)
        profileCard.addSubview(signOutButton)

        avatarLabel.backgroundColor = AppColors.orangeLight
        avatarLabel.textColor = AppColors.orange
        avatarLabel.font = .systemFont(ofSize: 25, weight: .bold)
        avatarLabel.textAlignment = .center
        avatarLabel.text = "П"
        avatarLabel.layer.cornerRadius = 30
        avatarLabel.clipsToBounds = true

        nameLabel.text = "Профиль пользователя"
        nameLabel.textColor = AppColors.textPrimary
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        emailLabel.text = "Войдите в аккаунт"
        emailLabel.textColor = AppColors.textSecondary
        emailLabel.font = .systemFont(ofSize: 14, weight: .regular)
        emailLabel.numberOfLines = 1

        signOutButton.setTitle("Выйти из аккаунта", for: .normal)
        signOutButton.setTitleColor(AppColors.orange, for: .normal)
        signOutButton.titleLabel?.font = .systemFont(
            ofSize: 15,
            weight: .semibold
        )
        signOutButton.backgroundColor = AppColors.orangeLight
        signOutButton.layer.cornerRadius = 14
        signOutButton.isEnabled = false
        signOutButton.alpha = 0.55
        signOutButton.addTarget(
            self,
            action: #selector(signOutButtonTapped),
            for: .touchUpInside
        )

        avatarLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(18)
            make.size.equalTo(60)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarLabel).offset(8)
            make.leading.equalTo(avatarLabel.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(18)
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.leading.trailing.equalTo(nameLabel)
        }

        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(avatarLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(18)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(18)
        }
    }

    private func setupAdsHeader() {
        adsHeaderView.addSubview(adsTitleLabel)
        adsHeaderView.addSubview(adsCountLabel)

        adsTitleLabel.text = "Мои объявления"
        adsTitleLabel.textColor = AppColors.textPrimary
        adsTitleLabel.font = .systemFont(ofSize: 21, weight: .bold)

        adsCountLabel.text = "0"
        adsCountLabel.textColor = AppColors.orange
        adsCountLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        adsCountLabel.textAlignment = .center
        adsCountLabel.backgroundColor = AppColors.orangeLight
        adsCountLabel.layer.cornerRadius = 14
        adsCountLabel.clipsToBounds = true

        adsTitleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }

        adsCountLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(
                adsTitleLabel.snp.trailing
            ).offset(12)
            make.size.equalTo(CGSize(width: 38, height: 28))
        }
    }

    private func setupEmptyView() {
        emptyView.backgroundColor = .clear
        emptyView.addSubview(emptyCard)

        emptyCard.backgroundColor = AppColors.cardBackground
        emptyCard.layer.cornerRadius = 22
        emptyCard.layer.borderWidth = 1
        emptyCard.layer.borderColor = AppColors.border.cgColor

        emptyCard.addSubview(emptyIconView)
        emptyCard.addSubview(emptyTitleLabel)
        emptyCard.addSubview(emptyMessageLabel)

        emptyIconView.image = UIImage(systemName: "car.fill")
        emptyIconView.tintColor = AppColors.orange
        emptyIconView.contentMode = .scaleAspectFit

        emptyTitleLabel.text = "Пока нет объявлений"
        emptyTitleLabel.textColor = AppColors.textPrimary
        emptyTitleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        emptyTitleLabel.textAlignment = .center

        emptyMessageLabel.text = "Ваши объявления появятся здесь"
        emptyMessageLabel.textColor = AppColors.textSecondary
        emptyMessageLabel.font = .systemFont(ofSize: 14, weight: .regular)
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.numberOfLines = 0

        emptyCard.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-30)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emptyIconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }

        emptyTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyIconView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        emptyMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyTitleLabel.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)

        activityIndicator.color = AppColors.orange
        activityIndicator.hidesWhenStopped = true

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func updateHeaderHeight() {
        let width = tableView.bounds.width

        guard width > 0 else { return }

        headerView.frame.size.width = width
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let size = headerView.systemLayoutSizeFitting(
            CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        if abs(headerView.frame.height - size.height) > 1 {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
        }
    }

    private func updateEmptyState() {
        adsCountLabel.text = "\(ads.count)"

        let shouldShowEmptyView = ads.isEmpty && emptyMessage != nil
        tableView.backgroundView = shouldShowEmptyView ? emptyView : nil

        tableView.reloadData()
    }

    private func updateUserInfo(user: AppUser?) {
        guard let user else {
            avatarLabel.text = "П"
            nameLabel.text = "Профиль пользователя"
            emailLabel.text = "Войдите в аккаунт"
            signOutButton.isEnabled = false
            signOutButton.alpha = 0.55
            return
        }

        let name = user.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = user.email.trimmingCharacters(in: .whitespacesAndNewlines)

        nameLabel.text = name.isEmpty ? "Профиль пользователя" : name
        emailLabel.text = email.isEmpty ? "Аккаунт" : email

        let avatarText = name.isEmpty ? email : name
        avatarLabel.text = avatarText.first.map {
            String($0).uppercased()
        } ?? "П"

        signOutButton.isEnabled = true
        signOutButton.alpha = 1
    }

    @objc private func signOutButtonTapped() {
        let alert = UIAlertController(
            title: "Выйти из аккаунта?",
            message: "Вы сможете войти снова в любое время.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Выйти", style: .destructive) { [weak self] _ in
                self?.presenter?.signOut()
            }
        )

        present(alert, animated: true)
    }

    private func showDeleteConfirmation(for ad: Ad) {
        let alert = UIAlertController(
            title: "Удалить объявление?",
            message: "Это действие нельзя отменить.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(
            UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                self?.presenter?.deleteAd(ad)
            }
        )

        present(alert, animated: true)
    }
}

// MARK: - ProfileViewInput

extension ProfileViewController {

    func modelUpdated(user: AppUser) {
        updateUserInfo(user: user)
    }

    func clearProfile() {
        updateUserInfo(user: nil)
        ads = []
        emptyMessage = nil
        updateEmptyState()
    }

    func modelUpdated(ads: [Ad]) {
        self.ads = ads

        if !ads.isEmpty {
            emptyMessage = nil
        }

        updateEmptyState()
    }

    func removeMyAd(id: String) {
        ads.removeAll { $0.id == id }

        if ads.isEmpty {
            emptyMessage = "У вас пока нет объявлений."
        }

        updateEmptyState()
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showEmptyState(message: String?) {
        emptyMessage = message

        if let message {
            emptyMessageLabel.text = message
        }

        updateEmptyState()
    }

    func showError(with message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }

    func didSignOut() {
        clearProfile()

        let alert = UIAlertController(
            title: "Вы вышли из аккаунта",
            message: nil,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Хорошо", style: .default) { [weak self] _ in
                self?.onLogout?()
            }
        )

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {

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

extension ProfileViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let ad = ads[indexPath.row]

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Удалить"
        ) { [weak self] _, _, completion in
            self?.showDeleteConfirmation(for: ad)
            completion(true)
        }

        deleteAction.backgroundColor = AppColors.orange

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
