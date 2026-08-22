import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    var onUnitsChanged: (() -> Void)?
    var onWindUnitsChanged: (() -> Void)?
    
    var presenter: SettingsPresenter?
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let temperatureCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let windCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let themeCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        return view
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "Единицы температуры"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var unitsSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["°C", "°F"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemBlue
        control.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.addTarget(self, action: #selector(unitsChanged), for: .valueChanged)
        return control
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Единицы ветра"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var windSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["М/с", "Км/ч"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .systemBlue
        control.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.addTarget(self, action: #selector(windChanged), for: .valueChanged)
        return control
    }()
    
    private let themeLabel: UILabel = {
        let label = UILabel()
        label.text = "Тёмная тема"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var themeSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .systemBlue
        toggle.thumbTintColor = .white
        toggle.addTarget(self, action: #selector(themeChanged), for: .valueChanged)
        return toggle
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.text = "Версия 1.0.0"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.textAlignment = .center
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPresenter()
        loadInitialSettings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
}

private extension SettingsViewController {
    
    func setupUI() {
        setupGradient()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(temperatureCard)
        temperatureCard.addSubview(temperatureLabel)
        temperatureCard.addSubview(unitsSegmentedControl)
        
        temperatureCard.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        unitsSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(windCard)
        windCard.addSubview(windSpeedLabel)
        windCard.addSubview(windSegmentedControl)
        
        windCard.snp.makeConstraints { make in
            make.top.equalTo(temperatureCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        windSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(windSpeedLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
            make.bottom.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(themeCard)
        themeCard.addSubview(themeLabel)
        themeCard.addSubview(themeSwitch)
        
        themeCard.snp.makeConstraints { make in
            make.top.equalTo(windCard.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        themeLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        themeSwitch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(themeCard.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
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
    
    func setupPresenter() {
        if presenter == nil {
            presenter = SettingsPresenter(storage: StorageService.shared)
        }
        presenter?.view = self
    }
    
    func loadInitialSettings() {
        guard let presenter = presenter else { return }
        
        let isMetric = presenter.getCurrentUnits() == "metric"
        unitsSegmentedControl.selectedSegmentIndex = isMetric ? 0 : 1
        
        let isKmh = presenter.getWindUnits() == "kmh"
        windSegmentedControl.selectedSegmentIndex = isKmh ? 1 : 0
        
        themeSwitch.setOn(presenter.isDarkTheme(), animated: false)
    }
    
    @objc func unitsChanged(_ sender: UISegmentedControl) {
        presenter?.changeUnits(sender.selectedSegmentIndex == 0)
        onUnitsChanged?()
    }
    
    @objc func windChanged(_ sender: UISegmentedControl) {
        presenter?.changeWindUnits(sender.selectedSegmentIndex == 1)
        onWindUnitsChanged?()
    }
    
    @objc func themeChanged(_ sender: UISwitch) {
        presenter?.changeTheme(sender.isOn)
        applyTheme(isDark: sender.isOn)
    }
    
    func applyTheme(isDark: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let style: UIUserInterfaceStyle = isDark ? .dark : .light
        
        windowScene.windows.forEach { window in
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
                window.overrideUserInterfaceStyle = style
            }
        }
    }
}

extension SettingsViewController: SettingsViewProtocol {
    
    func updateUnits(_ units: String) {}
    
    func updateTheme(_ isDark: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.themeSwitch.setOn(isDark, animated: true)
            self?.applyTheme(isDark: isDark)
        }
    }
}
