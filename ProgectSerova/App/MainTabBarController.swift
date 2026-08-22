import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemChromeMaterial)
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = .secondaryLabel
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        itemAppearance.selected.iconColor = .systemBlue
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
        
        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .clear
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.08
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 8
    }
    
    private func setupTabs() {
        let storage = StorageService.shared
        let weatherService = WeatherService()
        let weatherPresenter = WeatherPresenter(service: weatherService, storage: storage)
        let settingsPresenter = SettingsPresenter(storage: storage)
        let weatherVC = WeatherViewController(presenter: weatherPresenter)
        let weather = UINavigationController(rootViewController: weatherVC)
        let mapVC = WeatherMapViewController()
        let map = UINavigationController(rootViewController: mapVC)
        let settingsVC = SettingsViewController()
        settingsVC.presenter = settingsPresenter
        settingsPresenter.view = settingsVC
        settingsVC.onUnitsChanged = { [weak weatherPresenter] in
            let city = StorageService.shared.getLastCity()
            weatherPresenter?.loadWeather(for: city)
        }
        
        settingsVC.onWindUnitsChanged = { [weak weatherPresenter] in
            let city = StorageService.shared.getLastCity()
            weatherPresenter?.loadWeather(for: city)
        }
        
        let settings = UINavigationController(rootViewController: settingsVC)
        
        weather.tabBarItem = UITabBarItem(
            title: "Сегодня",
            image: UIImage(systemName: "cloud.sun.fill"),
            tag: 0
        )
        
        map.tabBarItem = UITabBarItem(
            title: "Карта",
            image: UIImage(systemName: "map.fill"),
            tag: 1
        )
        
        settings.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gearshape.fill"),
            tag: 2
        )
        
        viewControllers = [weather, map, settings]
        
        
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([
                    .font: UIFont.systemFont(ofSize: 10, weight: .medium)
                ], for: .normal)
            }
        }
    }
}
