import UIKit

@MainActor
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: Coordinator?
    let fileManager = FileManager.default

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        if window == nil {
            window = UIWindow(windowScene: windowScene)
        }

        guard let window = window else { return }

        if window.rootViewController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
                assertionFailure("Root view controller is not a UINavigationController")
                return
            }
            window.rootViewController = navigationController
        } else {
            guard window.rootViewController is UINavigationController else {
                assertionFailure("Root view controller is not a UINavigationController")
                return
            }
        }

        Style.configureAppearance(for: window)

        if let navigationController = window.rootViewController as? UINavigationController {
            coordinator = Coordinator(navigationController: navigationController)
            coordinator?.start()
        }

        if connectionOptions.urlContexts.isEmpty {
            try? fileManager.clearTemporaryDirectories()
        }

        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let context = URLContexts.first else { return }
        let url = context.url
        let openInPlace = context.options.openInPlace

        // MARK: - UNUSED WARNING Removed 5.Nov.2025
//        if let importedURL = try? fileManager.importFile(at: url, asCopy: true, deletingSource: !openInPlace),
//           let coordinator = coordinator {
//            coordinator.open(videoUrl: importedURL)
//        }
        if let importedURL = try? fileManager.importFile(at: url, asCopy: true, deletingSource: !openInPlace),
           let coordinator = coordinator {
            _ = coordinator.open(videoUrl: importedURL)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // No action needed here for clearing temporary directories.
    }
}
