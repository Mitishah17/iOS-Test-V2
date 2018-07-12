//
//  MainPresenter.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import Foundation

class MainPresenter : APIProtocol {
    
    static let shared = MainPresenter()

    lazy var apiManager : ApiManager = {
       let result = ApiManager()
        result.delegate = self
        return result
    }()
    
    var loginCompletionHandler : ((Bool, String) -> Void )?
    
    var loggedUserData : TestData? {
        guard let username = apiManager.loginUsername, username.isEmpty == false else {
            print("There was a error with logged user data")
            return nil
        }
        
        return TestData.getUser(name: username)
    }
    
    /// API Protocol 
    func loggedIn ( _ success : Bool, _ message: String ) {
        DispatchQueue.main.async {
            self.loginCompletionHandler?(success, message) // resuse later on 
        }
    }
    
    
    func login( _ user : String, _ password: String, completionHandler : @escaping ((Bool, String) -> Void ) ) {
        loginCompletionHandler = completionHandler
        apiManager.login(user, password: password, userJson: nil)
    }
    
    
    func signUp( _ user : String, _ password: String, completionHandler : @escaping ((Bool, String) -> Void ) ) {
        loginCompletionHandler = completionHandler
        apiManager.createUser(user, password: password)
    }
    
    func updateUserValues ( _ coreDataUser : TestData ) {
        apiManager.updateUserValues( coreDataUser )
    }
    
    
}
