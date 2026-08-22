import UIKit
import SnapKit

final class WeatherViewController: UIViewController {
    
    private let presenter: WeatherPresenter
    private var hourlyData: [ForecastItem] = []
    private var dailyData: [ForecastItem] = []
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    private let weatherIconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 50
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 10
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 76, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        return label
    }()
    
    private let hourlyLabel: UILabel = {
        let label = UILabel()
        label.text = "Почасовой прогноз"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var hourlyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.identifier)
        collection.showsHorizontalScrollIndicator = false
        return collection
    }()
    
    private let dailyLabel: UILabel = {
        let label = UILabel()
        label.text = "5 дней"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var dailyTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.isScrollEnabled = false
        table.layer.cornerRadius = 16
        table.clipsToBounds = true
        table.bounces = false
        return table
    }()
    
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var gradientLayer: CAGradientLayer?
    private var dailyTableHeightConstraint: Constraint?
    
    init(presenter: WeatherPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupDelegates()
        presenter.view = self
        let lastCity = StorageService.shared.getLastCity()
        presenter.loadWeather(for: lastCity)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let lastCity = StorageService.shared.getLastCity()
        presenter.loadWeather(for: lastCity)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}

private extension WeatherViewController {
    
    func setupDelegates() {
        hourlyCollectionView.dataSource = self
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
    }
    
    func setupUI() {
        setupGradient()
        setupScrollView()
        setupHeaderStack()
        setupWeatherIcon()
        setupTemperatureSection()
        setupHourlySection()
        setupDailySection()
        setupLoader()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(view.snp.width)
        }
    }
    
    func setupHeaderStack() {
        headerStackView.addArrangedSubview(cityLabel)
        headerStackView.addArrangedSubview(dateLabel)
        
        contentView.addSubview(headerStackView)
        
        headerStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupWeatherIcon() {
        contentView.addSubview(weatherIconContainer)
        weatherIconContainer.addSubview(iconImageView)
        
        weatherIconContainer.snp.makeConstraints { make in
            make.top.equalTo(headerStackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func setupTemperatureSection() {
        contentView.addSubview(temperatureLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(feelsLikeLabel)
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherIconContainer.snp.bottom).offset(8)
            make.centerX.equalToSuperview().offset(6)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        feelsLikeLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupHourlySection() {
        contentView.addSubview(hourlyLabel)
        contentView.addSubview(hourlyCollectionView)
        
        hourlyLabel.snp.makeConstraints { make in
            make.top.equalTo(feelsLikeLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(20)
        }
        
        hourlyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hourlyLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
    }
    
    func setupDailySection() {
        contentView.addSubview(dailyLabel)
        contentView.addSubview(dailyTableView)
        
        dailyLabel.snp.makeConstraints { make in
            make.top.equalTo(hourlyCollectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        dailyTableView.snp.makeConstraints { make in
            make.top.equalTo(dailyLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            dailyTableHeightConstraint = make.height.equalTo(0).constraint
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func setupLoader() {
        view.addSubview(loader)
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
    
    func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain,
            target: self,
            action: #selector(openSearch)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.clockwise"),
            style: .plain,
            target: self,
            action: #selector(refreshData)
        )
    }
    
    func updateDailyTableHeight() {
        let height = CGFloat(dailyData.count) * 70
        dailyTableHeightConstraint?.update(offset: height)
    }
    
    @objc func openSearch() {
        let storage = StorageService.shared
        let presenter = SearchPresenter(storage: storage)
        let viewController = SearchViewController(presenter: presenter)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func refreshData() {
        let lastCity = StorageService.shared.getLastCity()
        presenter.loadWeather(for: lastCity)
    }
}

extension WeatherViewController: WeatherViewProtocol {
    
    func renderWeather(_ viewModel: WeatherViewModel) {
        cityLabel.text = viewModel.city
        dateLabel.text = viewModel.date
        temperatureLabel.text = viewModel.temperature
        descriptionLabel.text = viewModel.description
        feelsLikeLabel.text = viewModel.feelsLike
        iconImageView.image = UIImage(systemName: viewModel.icon)
    }
    
    func renderHourlyForecast(_ items: [ForecastItem]) {
        hourlyData = items
        hourlyCollectionView.reloadData()
    }
    
    func renderDailyForecast(_ items: [ForecastItem]) {
        dailyData = items
        dailyTableView.reloadData()
        updateDailyTableHeight()
    }
    
    func showError(_ message: String) {
        guard !(presentedViewController is UIAlertController) else { return }
        
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HourlyCell.identifier,
            for: indexPath
        ) as? HourlyCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hourlyData[indexPath.item])
        return cell
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DailyForecastCell.identifier,
            for: indexPath
        ) as? DailyForecastCell else {
            return UITableViewCell()
        }
        cell.configure(with: dailyData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dailyData[indexPath.row]
        let city = StorageService.shared.getLastCity()
        let presenter = DayDetailsPresenter(city: city)
        let viewController = DayDetailsViewController(presenter: presenter, item: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
