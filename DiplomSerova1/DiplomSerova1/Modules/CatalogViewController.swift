//
//  CatalogViewController.swift
//  DiplomSerova1
//
//  Created by Дарья on 08.11.2026.
//

import UIKit
import SnapKit

final class CatalogViewController: UIViewController {

    private let presenter: CatalogPresenter
    private var ads: [Ad] = []

    private let headerEyebrowLabel = UILabel()
    private let headerTitleLabel = UILabel()
    private let headerSubtitleLabel = UILabel()

    private let searchBar = UISearchBar()
    private let historyScroll = UIScrollView()
    private let historyStack = UIStackView()
    private let clearHistoryButton = UIButton(type: .system)

    private let filterCardView = UIView()
    private let filterTitleLabel = UILabel()
    private let categoryButton = UIButton(type: .system)
    private let minField = UITextField()
    private let maxField = UITextField()

    private let resultsTitleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let loader = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()

    private var historyHeightConstraint: Constraint?

    init(presenter: CatalogPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.view = self
        setupUI()
        presenter.fetchAds()
    }

    private func setupUI() {
        view.backgroundColor = AppColors.catalogBackground
        navigationItem.title = "av.by"
        navigationController?.navigationBar.tintColor = AppColors.orange

        headerEyebrowLabel.text = "АВТО • МОТО • ДЕТАЛИ"
        headerEyebrowLabel.font = .systemFont(ofSize: 11, weight: .bold)
        headerEyebrowLabel.textColor = AppColors.orange

        headerTitleLabel.text = "Находки для дороги"
        headerTitleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headerTitleLabel.textColor = AppColors.textPrimary
        headerTitleLabel.numberOfLines = 0

        headerSubtitleLabel.text = "Техника и детали для новых маршрутов."
        headerSubtitleLabel.font = .systemFont(ofSize: 14)
        headerSubtitleLabel.textColor = AppColors.textSecondary
        headerSubtitleLabel.numberOfLines = 0

        searchBar.placeholder = "Марка, модель или деталь"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.backgroundColor = .clear
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        searchBar.searchTextField.backgroundColor = AppColors.cardBackground
        searchBar.searchTextField.textColor = AppColors.textPrimary
        searchBar.searchTextField.font = .systemFont(ofSize: 15)
        searchBar.searchTextField.layer.cornerRadius = 14
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.borderColor = AppColors.border.cgColor
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.leftView?.tintColor = AppColors.orange

        historyScroll.showsHorizontalScrollIndicator = false
        historyStack.axis = .horizontal
        historyStack.spacing = 8

        clearHistoryButton.setTitle("Очистить", for: .normal)
        clearHistoryButton.setTitleColor(AppColors.textSecondary, for: .normal)
        clearHistoryButton.titleLabel?.font = .systemFont(ofSize: 13)
        clearHistoryButton.isHidden = true
        clearHistoryButton.addTarget(
            self,
            action: #selector(clearHistory),
            for: .touchUpInside
        )

        setupCategoryButton()

        filterCardView.backgroundColor = AppColors.cardBackground
        filterCardView.layer.cornerRadius = 18
        filterCardView.layer.borderWidth = 1
        filterCardView.layer.borderColor = AppColors.border.cgColor

        filterTitleLabel.text = "Фильтры"
        filterTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        filterTitleLabel.textColor = AppColors.textPrimary

        configurePrice(minField, placeholder: "Цена от")
        configurePrice(maxField, placeholder: "Цена до")

        minField.addTarget(
            self,
            action: #selector(priceChanged),
            for: .editingChanged
        )

        maxField.addTarget(
            self,
            action: #selector(priceChanged),
            for: .editingChanged
        )

        resultsTitleLabel.text = "Свежие находки"
        resultsTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        resultsTitleLabel.textColor = AppColors.textPrimary

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
        tableView.keyboardDismissMode = .onDrag

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.orange
        refreshControl.addTarget(
            self,
            action: #selector(refresh),
            for: .valueChanged
        )
        tableView.refreshControl = refreshControl

        emptyLabel.text = "Пока нет объявлений"
        emptyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        emptyLabel.textColor = AppColors.textSecondary
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true

        loader.color = AppColors.orange
        loader.hidesWhenStopped = true

        setupLayout()
    }

    private func setupCategoryButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Все категории"
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 7
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 7,
            leading: 11,
            bottom: 7,
            trailing: 11
        )
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = AppColors.orange
        configuration.baseBackgroundColor = AppColors.orangeLight

        categoryButton.configuration = configuration
        categoryButton.showsMenuAsPrimaryAction = true
        categoryButton.menu = makeCategoryMenu()
    }

    private func setupLayout() {
        view.addSubview(headerEyebrowLabel)
        view.addSubview(headerTitleLabel)
        view.addSubview(headerSubtitleLabel)
        view.addSubview(searchBar)
        view.addSubview(historyScroll)
        view.addSubview(clearHistoryButton)
        view.addSubview(filterCardView)
        view.addSubview(resultsTitleLabel)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(loader)

        historyScroll.addSubview(historyStack)

        filterCardView.addSubview(filterTitleLabel)
        filterCardView.addSubview(categoryButton)
        filterCardView.addSubview(minField)
        filterCardView.addSubview(maxField)

        headerEyebrowLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        headerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerEyebrowLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        headerSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerSubtitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(48)
        }

        historyScroll.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(clearHistoryButton.snp.leading).offset(-8)
            historyHeightConstraint = make.height.equalTo(0).constraint
        }

        clearHistoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(historyScroll)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        historyStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }

        filterCardView.snp.makeConstraints { make in
            make.top.equalTo(historyScroll.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        filterTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalTo(categoryButton)
            make.trailing.lessThanOrEqualTo(categoryButton.snp.leading).offset(-8)
        }

        categoryButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(34)
        }

        minField.snp.makeConstraints { make in
            make.top.equalTo(categoryButton.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(14)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(14)
        }

        maxField.snp.makeConstraints { make in
            make.leading.equalTo(minField.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(14)
            make.top.equalTo(minField)
            make.height.equalTo(minField)
            make.width.equalTo(minField)
        }

        resultsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(filterCardView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(resultsTitleLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView)
            make.leading.trailing.equalTo(tableView).inset(24)
        }

        loader.snp.makeConstraints { make in
            make.center.equalTo(tableView)
        }
    }

    private func configurePrice(_ field: UITextField, placeholder: String) {
        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: AppColors.textSecondary]
        )
        field.textColor = AppColors.textPrimary
        field.borderStyle = .none
        field.backgroundColor = AppColors.catalogBackground
        field.keyboardType = .numberPad
        field.font = .systemFont(ofSize: 14, weight: .medium)
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = AppColors.border.cgColor
        field.clipsToBounds = true
        field.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: 12, height: 1)
        )
        field.leftViewMode = .always
    }

    private func makeCategoryMenu() -> UIMenu {
        var actions = [
            UIAction(title: "Все категории") { [weak self] _ in
                self?.updateCategoryButtonTitle("Все категории")
                self?.presenter.updateCategory(nil)
            }
        ]

        actions += AdCategory.allCases.map { category in
            UIAction(title: category.rawValue) { [weak self] _ in
                self?.updateCategoryButtonTitle(category.rawValue)
                self?.presenter.updateCategory(category)
            }
        }

        return UIMenu(title: "Категория", children: actions)
    }

    private func updateCategoryButtonTitle(_ title: String) {
        var configuration = categoryButton.configuration
            ?? UIButton.Configuration.filled()

        configuration.title = title
        categoryButton.configuration = configuration
    }

    @objc private func priceChanged() {
        presenter.updatePrice(
            min: minField.text ?? "",
            max: maxField.text ?? ""
        )
    }

    @objc private func refresh() {
        presenter.loadFirst()
    }

    @objc private func clearHistory() {
        presenter.clearHistory()
    }

    private func openDetails(_ ad: Ad) {
        let controller = AdDetailsViewController(ad: ad)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - CatalogViewInput
extension CatalogViewController: CatalogViewInput {

    func modelUpdated(ads: [Ad]) {
        self.ads = ads
        emptyLabel.isHidden = !ads.isEmpty
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func showHistory(_ items: [String]) {
        historyStack.arrangedSubviews.forEach {
            historyStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let hasItems = !items.isEmpty

        historyScroll.isHidden = !hasItems
        clearHistoryButton.isHidden = !hasItems
        historyHeightConstraint?.update(offset: hasItems ? 34 : 0)

        for item in items {
            let button = UIButton(type: .system)

            var configuration = UIButton.Configuration.filled()
            configuration.title = item
            configuration.image = UIImage(systemName: "clock")
            configuration.imagePlacement = .leading
            configuration.imagePadding = 5
            configuration.contentInsets = NSDirectionalEdgeInsets(
                top: 5,
                leading: 10,
                bottom: 5,
                trailing: 10
            )
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = AppColors.textSecondary
            configuration.baseBackgroundColor = AppColors.orangeLight

            button.configuration = configuration

            button.addAction(
                UIAction { [weak self] _ in
                    self?.searchBar.text = item
                    self?.presenter.updateTitle(item)
                },
                for: .touchUpInside
            )

            historyStack.addArrangedSubview(button)
        }
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }

    func showPageLoading(_ isLoading: Bool) {
        if isLoading {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.color = AppColors.orange
            spinner.startAnimating()
            spinner.frame = CGRect(
                x: 0,
                y: 0,
                width: tableView.bounds.width,
                height: 44
            )
            tableView.tableFooterView = spinner
        } else {
            tableView.tableFooterView = UIView()
        }
    }

    func showError(with message: String) {
        tableView.refreshControl?.endRefreshing()

        guard presentedViewController == nil else { return }

        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension CatalogViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.updateTitle(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.submitSearch(searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CatalogViewController: UITableViewDataSource, UITableViewDelegate {

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

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        guard ads.indices.contains(indexPath.row) else { return }
        openDetails(ads[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == ads.count - 1 {
            presenter.loadNext()
        }
    }
}
