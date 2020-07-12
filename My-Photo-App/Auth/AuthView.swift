//
//  AuthView.swift
//  My-Photo-App
//
//  Created by Kyle Lee on 7/10/20.
//

import Amplify
import AWSPluginsCore
import SwiftUI

struct AuthView: View {
    
    let window: UIWindow
    let didSignIn: (_ userId: String) -> Void
    
    var body: some View {
        Button("Sign Up", action: signInWithWebUI)
            .onAppear(perform: fetchCurrentAuthSession)
    }
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            
            switch result {
            case .success(let provider as AuthCognitoIdentityProvider):
                
                do {
                    let identityId = try provider.getIdentityId().get()
                    didSignIn(identityId)
                    
                } catch {
                    signInWithWebUI()
                }

            default:
                print("Fetch session failed")
            }
        }
    }
    
    func signInWithWebUI() {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: window) { result in
            switch result {
            case .success:
                print("Sign in succeeded")
                fetchCurrentAuthSession()
                
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(window: UIWindow(), didSignIn: {_ in})
    }
}
