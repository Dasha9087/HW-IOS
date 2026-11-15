import UIKit
import FirebaseAuth

final class ModuleBuilder {

    private static func configureNavigationBar(
        _ navigation: UINavigationController
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.catalogBackground
        appearance.shadowColor = AppColors.border
        appearance.titleTextAttributes = [
            .foregroundColor: AppColors.textPrimary
        ]

        navigation.navigationBar.standardAppearance = appearance
        navigation.navigationBar.scrollEdgeAppearance = appearance
        navigation.navigationBar.compactAppearance = appearance
        navigation.navigationBar.tintColor = AppColors.orange
    }

    static func createCatalogModule() -> (
        UINavigationController,
        CatalogPresenter
    ) {
        let presenter = CatalogPresenter(
            service: AdsService(),
            auth: AuthService(),
            storage: StorageService.shared
        )

        let controller = CatalogViewController(presenter: presenter)
        presenter.view = controller

        let navigation = UINavigationController(
            rootViewController: controller
        )
        configureNavigationBar(navigation)

        navigation.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )

        return (navigation, presenter)
    }

    static func createFavoritesModule() -> UINavigationController {
        let controller = FavoritesViewController()
        let navigation = UINavigationController(
            rootViewController: controller
        )
        configureNavigationBar(navigation)

        navigation.tabBarItem = UITabBarItem(
            title: "Избранное",
            image: UIImage(systemName: "heart"),
            tag: 1
        )

        return navigation
    }

    static func createCreateAdModule(
        onPublished: @escaping () -> Void
    ) -> UINavigationController {
        let controller = CreateAdViewController()
        controller.onPublished = onPublished

        let navigation = UINavigationController(
            rootViewController: controller
        )
        configureNavigationBar(navigation)

        navigation.tabBarItem = UITabBarItem(
            title: "Разместить",
            image: UIImage(systemName: "plus.circle"),
            tag: 2
        )

        return navigation
    }

    static func createProfileModule(
        onLogout: @escaping () -> Void
    ) -> UINavigationController {
        let controller = ProfileViewController()
        controller.onLogout = onLogout

        let presenter = ProfilePresenter(
            adsService: AdsService(),
            authService: AuthService()
        )

        presenter.view = controller
        controller.presenter = presenter

        let navigation = UINavigationController(
            rootViewController: controller
        )

        configureNavigationBar(navigation)

        navigation.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 3
        )

        return navigation
    }

    static func createAuthModule(
        onSuccess: @escaping () -> Void
    ) -> UIViewController {
        let presenter = AuthPresenter(
            auth: AuthService(),
            storage: StorageService.shared
        )

        let controller = LoginViewController(presenter: presenter)
        controller.onSuccess = onSuccess

        let navigation = UINavigationController(
            rootViewController: controller
        )
        configureNavigationBar(navigation)

        navigation.modalPresentationStyle = .fullScreen
        navigation.isModalInPresentation = true

        return navigation
    }
}

final class MainTabBarController: UITabBarController {

    private var catalogPresenter: CatalogPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAuthIfNeeded()
    }

    func showAuthIfNeeded() {
        guard Auth.auth().currentUser == nil,
              presentedViewController == nil else {
            return
        }

        let auth = ModuleBuilder.createAuthModule { [weak self] in
            self?.dismiss(animated: true) {
                self?.catalogPresenter?.loadFirst()
            }
        }

        present(auth, animated: true)
    }

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.cardBackground
        appearance.shadowColor = AppColors.border

        let itemAppearance = UITabBarItemAppearance()

        itemAppearance.normal.iconColor = AppColors.textSecondary
        itemAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppColors.textSecondary
        ]

        itemAppearance.selected.iconColor = AppColors.orange
        itemAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppColors.orange
        ]

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = AppColors.orange
        tabBar.unselectedItemTintColor = AppColors.textSecondary
    }

    private func setupTabs() {
        let (catalogNavigation, presenter) =
            ModuleBuilder.createCatalogModule()
        catalogPresenter = presenter

        let favorites = ModuleBuilder.createFavoritesModule()

        let create = ModuleBuilder.createCreateAdModule {
            [weak self, weak presenter] in
            presenter?.loadFirst()
            self?.selectedIndex = 0
        }

        let profile = ModuleBuilder.createProfileModule { [weak self] in
            self?.showAuthIfNeeded()
        }

        viewControllers = [
            catalogNavigation,
            favorites,
            create,
            profile
        ]
    }
}
