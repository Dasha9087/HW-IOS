import UIKit

final class ModuleBuilder {
    
    static func createWeatherModule() -> (UINavigationController, WeatherPresenter) {
        let storage = StorageService.shared
        let weatherService = WeatherService()
        let weatherPresenter = WeatherPresenter(service: weatherService, storage: storage)
        let weatherVC = WeatherViewController(presenter: weatherPresenter)
        
        let navigation = UINavigationController(rootViewController: weatherVC)
        navigation.tabBarItem = UITabBarItem(
            title: "Сегодня",
            image: UIImage(systemName: "cloud.sun.fill"),
            tag: 0
        )
        return (navigation, weatherPresenter)
    }
    
    static func createMapModule() -> UINavigationController {
        let weatherService = WeatherService()
        let locationService = LocationService()
        
        let presenter = WeatherMapPresenter(
            weatherService: weatherService,
            locationService: locationService
        )
        
        let mapVC = WeatherMapViewController(presenter: presenter)
        
        presenter.view = mapVC
        
        let navigation = UINavigationController(rootViewController: mapVC)
        navigation.tabBarItem = UITabBarItem(
            title: "Карта",
            image: UIImage(systemName: "map.fill"),
            tag: 1
        )
        return navigation
    }
    
    static func createSettingsModule(weatherPresenter: WeatherPresenter?) -> UINavigationController {
        let storage = StorageService.shared
        let settingsPresenter = SettingsPresenter(storage: storage)
        let settingsVC = SettingsViewController(presenter: settingsPresenter)
        
        settingsPresenter.view = settingsVC
        
        settingsVC.onUnitsChanged = { [weak weatherPresenter] in
            let city = StorageService.shared.getLastCity()
            weatherPresenter?.loadWeather(for: city)
        }
        
        settingsVC.onWindUnitsChanged = { [weak weatherPresenter] in
            let city = StorageService.shared.getLastCity()
            weatherPresenter?.loadWeather(for: city)
        }
        
        let navigation = UINavigationController(rootViewController: settingsVC)
        navigation.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gearshape.fill"),
            tag: 2
        )
        return navigation
    }
}

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
        let (weatherNav, weatherPresenter) = ModuleBuilder.createWeatherModule()
        let mapNav = ModuleBuilder.createMapModule()
        let settingsNav = ModuleBuilder.createSettingsModule(weatherPresenter: weatherPresenter)
        
        viewControllers = [weatherNav, mapNav, settingsNav]
        
        if let items = tabBar.items {
            for item in items {
                item.setTitleTextAttributes([
                    .font: UIFont.systemFont(ofSize: 10, weight: .medium)
                ], for: .normal)
            }
        }
    }
}
