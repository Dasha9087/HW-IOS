//
//  SceneDelegate.swift
//  HW9
//
//  Created by Дарья on 17.05.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = scene as? UIWindowScene else { return }

        window = UIWindow(windowScene: scene)

        let tabBarController = UITabBarController()

        // Tab 1: present()
        let modalRootVC = ModalTabViewController()
        modalRootVC.tabBarItem = UITabBarItem(
            title: "Modal",
            image: UIImage(systemName: "hand.raised.fill"),
            tag: 0
        )

        // Tab 2: navigation push
        let push1RootVC = PushTab1RootViewController()
        push1RootVC.tabBarItem = UITabBarItem(
            title: "Push 1",
            image: UIImage(systemName: "gearshape.fill"),
            tag: 1
        )
        let push1Nav = UINavigationController(rootViewController: push1RootVC)

        // Tab 3: navigation push
        let push2RootVC = PushTab2RootViewController()
        push2RootVC.tabBarItem = UITabBarItem(
            title: "Push 2",
            image: UIImage(systemName: "bell.fill"),
            tag: 2
        )
        let push2Nav = UINavigationController(rootViewController: push2RootVC)

        tabBarController.setViewControllers(
            [modalRootVC, push1Nav, push2Nav],
            animated: false
        )

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
