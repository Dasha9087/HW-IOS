import UIKit
import SnapKit

final class SearchViewController: UIViewController {
    
    private let presenter: SearchPresenter
    private var displayItems: [String] = []
    private var isHistoryMode: Bool = true
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.searchBarStyle = .minimal
        bar.placeholder = "Введите город"
        bar.backgroundColor = .clear
        bar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        bar.searchTextField.layer.cornerRadius = 12
        bar.searchTextField.clipsToBounds = true
        bar.searchTextField.textColor = .white
        bar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Введите город",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.6)]
        )
        bar.searchTextField.leftView?.tintColor = .white.withAlphaComponent(0.6)
        return bar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.keyboardDismissMode = .onDrag
        return table
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "История поиска пуста"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.6)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Очистить историю", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        return button
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    init(presenter: SearchPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.view = self
        presenter.loadState(with: searchBar.text)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.loadState(with: searchBar.text)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}

private extension SearchViewController {
    
    func setupUI() {
        setupGradient()
        
        navigationItem.title = "Поиск города"
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 60
        tableView.estimatedRowHeight = 60
        
        view.addSubview(searchBar)
        view.addSubview(clearButton)
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        clearButton.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(clearButton.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.15, green: 0.30, blue: 0.70, alpha: 1.0).cgColor,
            UIColor(red: 0.35, green: 0.15, blue: 0.55, alpha: 1.0).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        view.layer.insertSublayer(gradient, at: 0)
        gradientLayer = gradient
    }
    
    @objc func clearTapped() {
        presenter.clearHistory()
    }
}

extension SearchViewController: SearchViewProtocol {
    
    func display(items: [String], isHistory: Bool) {
        self.displayItems = items
        self.isHistoryMode = isHistory
        
        tableView.reloadData()
        
        if isHistoryMode {
            clearButton.isHidden = items.isEmpty
            emptyStateLabel.text = "История поиска пуста"
            emptyStateLabel.isHidden = !items.isEmpty
        } else {
            clearButton.isHidden = true
            emptyStateLabel.text = "Ничего не найдено"
            emptyStateLabel.isHidden = !items.isEmpty
        }
    }
    
    func closeSearch() {
        navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.loadState(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        presenter.searchCity(text)
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchHistoryCell.identifier,
            for: indexPath
        ) as? SearchHistoryCell else {
            return UITableViewCell()
        }
        cell.configure(with: displayItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectCity(displayItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard isHistoryMode else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, _ in
            self?.presenter.deleteItem(at: indexPath.row)
        }
        delete.backgroundColor = UIColor.systemRed.withAlphaComponent(0.7)
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
