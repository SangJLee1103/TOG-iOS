//
//  SceneDelegate.swift
//  TOG
//
//  Created by 이상준 on 3/24/24.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        window?.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window?.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.setInitialViewController()
        }
    }
    
    private func setInitialViewController() {
        if let uid = Auth.auth().currentUser?.uid {
            UserRepositoryImpl().fetchUser(uid: uid) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        UserManager.shared.user = user
                        self?.window?.rootViewController = UINavigationController(rootViewController: ChatViewController(viewModel: ChatViewModel(chatRepository: ChatRepositoryImpl())))
                    case .failure:
                        self?.window?.rootViewController = UINavigationController(rootViewController: SignInViewController(viewModel: SignInViewModel(userRepository: UserRepositoryImpl())))
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.window?.rootViewController = UINavigationController(rootViewController: SignInViewController(viewModel: SignInViewModel(userRepository: UserRepositoryImpl())))
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}
