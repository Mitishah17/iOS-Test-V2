//
//  APIManager.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import Foundation
// 
protocol APIProtocol {
    func loggedIn ( _ success : Bool, _ message : String )
}

class ApiManager {
    
    var delegate : APIProtocol?
    
    var token : String?
    
    var loginUsername : String?
    
    var loginPassword : String?
    
    var loginId : Int64?
    
    var hash: String?
    
    var number: Int?

    // Saves the testdata to the userdata and then the notification will notify the ui that requires to be updated
    func saveUser ( jsonDict : [String:Any] ) {
        guard let name = loginUsername else { return }
        let userData = TestData.updateUserData(name: name, jsonDict: jsonDict)
        loginId = userData.user_id
        NotificationCenter.default.post(name: Notification.Name(rawValue: "userDataRefreshed"), object: userData)
    }
    
    func login ( _ user : String, password : String, userJson : [String:Any]? ) {
        //unwrapping the url
        guard let url = URL(string: "https://mirror-ios-test.herokuapp.com/auth") else { return }
        // creating dict
        let userDict = ["username": user, "password" : password]
        //converting the Json object into a dict
        guard let uploadData = try? JSONSerialization.data(withJSONObject: userDict, options: JSONSerialization.WritingOptions.prettyPrinted) else { return }
        
        // creating the request for the url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Excuting the request
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            // in case of connection error
            guard error == nil else {
                self.delegate?.loggedIn(false, "Connection error: \(error?.localizedDescription ?? "")")
                return
            }
            // Did not recieve data
            guard let data = data else {
                self.delegate?.loggedIn(false, "Issue getting user info)")
                return
            }
            
            //Reading the json object recieved from the server
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else {
                    self.delegate?.loggedIn(false, "Issue reading user info")
                    return
                }
                //taking the token recieved and logging in
                if let token = json["access_token"] as? String {
                    self.token = token
                    self.loginUsername = user
                    self.loginPassword = password
                    
                    // If we are coming from the CreateUser func, we do have the payload and therefore it is not necessary to re-download it.
                    //getting your user data and informing our delegate that we have created that we have logged in
                    if userJson == nil {
                        if let user = TestData.getUser(name: user) {
                            self.getUserData(userId: user.user_id)
                            self.delegate?.loggedIn(true, "")
                        } else {
                            self.delegate?.loggedIn(false, "User never logged in on this device therefore can't login")
                        }
                    } else {
                        self.delegate?.loggedIn(true, "")
                    }
                    
                } else {
                    if let desc = json["description"] as? String {
                        self.delegate?.loggedIn(false, desc)
                    } else {
                        self.delegate?.loggedIn(false, "Can not get token")
                    }
                }
            } catch {
                self.delegate?.loggedIn(false, "Can not get token: \(error.localizedDescription)")
            }
            
        }
        //Starting the upload operation
        task.resume()
        
    }
    
    func createUser ( _ user : String, password : String ) {
        
        loginUsername = nil
        loginPassword = nil
        loginId = nil
        
        //unwrapping the url
        guard let url = URL(string: "https://mirror-ios-test.herokuapp.com/users") else { return }
        // creating dict
        let userDict = ["username": user, "password" : password]
        //converting the Json object into a dict
        guard let uploadData = try? JSONSerialization.data(withJSONObject: userDict, options: JSONSerialization.WritingOptions.prettyPrinted) else { return }
        // creating the request for the url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Excuting the request
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            // in case of connection error
            guard error == nil else {
                print("An error happened", error?.localizedDescription ?? "")
                return
            }
            // Did not recieve data
            guard let data = data else {
                //to add error handling
                return
            }
            
            //Reading the json object recieved from the server
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    self.loginId = json["id"] as? Int64
                    print("\(self.loginUsername)")
                    self.loginUsername = json["username"] as? String
                    print("\(self.loginUsername)")
                    self.login(user, password: password, userJson: json)
                    //let tData = TestData()
                    //if tData.magic_hash == nil {
                    //self.updateUserValues(tData)
                   // }
                    // Saving the user after creating a user
                       self.saveUser(jsonDict: json)
                    //print("JSON", json)
                } else {
                    print("Error creating user")
                }
            } catch {
                //to add error handling
                print("Error", error)
            }
  
        }
        //Starting the upload operation
        task.resume()
    }

    func getUserData ( userId : Int64 ) {
        //unwrapping the token
        guard let token = token else {
            //to add error handling
            return
        }
        //unwrapping the url
        guard let url = URL(string: "https://mirror-ios-test.herokuapp.com/users/\(userId)") else { return }
        // creating the request for the url
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        // Excuting the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // in case of connection error
            guard error == nil else {
                print("An error happened", error?.localizedDescription ?? "")
                return
            }
            // Did not recieve data
            guard let data = data else {
                 //to add error handling
                return
            }
            //Reading the json object recieved from the server
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    // save the user to core data an ui
                        self.saveUser(jsonDict: json)

                    // print("JSON getUserData", json)
                } else {
                    print("Error getting user data")
                }
            } catch {
                print("GETDATA Error attempting to get JSON", error)
            }
        }
        //Starting the upload operation
        task.resume()
    }
    
    func updateUserValues ( _ coreDataUser : TestData ) {
         //unwrapping the token
        guard let token = token else {
             //to add error handling
            return
        }
         //unwrapping the userId
        guard let userId = loginId else {
             //to add error handling
            return
        }
         //unwrapping the url
        guard let url = URL(string: "https://mirror-ios-test.herokuapp.com/users/\(userId)") else { return }
        
        //converting the Json object into a dict
        guard let uploadData = try? JSONSerialization.data(withJSONObject: coreDataUser.jsonDict, options: JSONSerialization.WritingOptions.prettyPrinted) else { return }
    
        // creating the request for the url
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("JWT \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = uploadData
        // Excuting the request
        let task = URLSession.shared.uploadTask(with: request, from: nil) { data, response, error in
            // in case of connection error
            guard error == nil else {
                print("An error happened", error?.localizedDescription ?? "")
                return
            }
            // Did not recieve data
            guard let data = data else {
                return
            }
            //Reading the json object recieved from the server
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] {
                    self.saveUser(jsonDict: json)
                } else {
                    print("Error getting updated user data")
                }
            } catch {
                print("updateUserValues Error attempting to get JSON", error)
            }

        }
        //Starting the upload operation
        task.resume()
    }
}
