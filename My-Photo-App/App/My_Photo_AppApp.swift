//
//  My_Photo_AppApp.swift
//  My-Photo-App
//
//  Created by Kyle Lee on 7/9/20.
//

import Amplify
import AmplifyPlugins
import SwiftUI

@main
struct My_Photo_AppApp: App {
    
    var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        else { return UIWindow() }
        
        return window
    }
    
    @State var userId: String?
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            if let userId = self.userId {
                GalleryView(userId: userId) {
                    self.userId = nil
                }
            } else {
                AuthView(window: window) {
                    userId = $0
                }
            }
        }
    }

    func configureAmplify() {
        do {
            // Auth
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            
            // DataStore
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            
            // Storage
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            try Amplify.configure()
            print("Amplify configured 🥳")
            
        } catch {
            print("Failed to configure Amplify", error)
        }
    }
}
