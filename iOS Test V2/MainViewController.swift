//
//  MainViewController.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var ageText : UITextField!
    @IBOutlet weak var heightText : UITextField!
    @IBOutlet weak var likesSwitch : UISwitch!
    @IBOutlet weak var ageLabel : UILabel!
    @IBOutlet weak var heightLabel : UILabel!
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var magicNumberLabel : UILabel!
    @IBOutlet weak var magicHashLabel : UILabel!
    
    var coreDataUser : TestData?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        
        if let userData = MainPresenter.shared.loggedUserData {
            updateUserInterface(userData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (magicHashLabel.text == nil) || (magicNumberLabel.text == nil) {
            MainPresenter.shared.updateUserValues(coreDataUser!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataReceived(_:)), name: Notification.Name(rawValue: "userDataRefreshed"), object: self)
    }
    

    // Saving back to server and core data with values from the UI and updating the other other derived elements on the UI
    @IBAction func saveUserData ( _ sender : Any? ) {
        
        /// prepare string with differences 
        /// present alert, with confirm button 
        
            if let coreDataUser = coreDataUser {
            coreDataUser.likes_javascript =  likesSwitch.isOn ? 1 : 0
            coreDataUser.age = Int64(ageText.text ?? "") ?? 0
            coreDataUser.height = Int32(heightText.text ?? "") ?? 0
            self.coreDataUser = coreDataUser
            MainPresenter.shared.updateUserValues(coreDataUser)
            updateUserInterface(coreDataUser)
        }
 
    }
    //Log out
    @IBAction func logOut(_ sender: UIButton) {
     _ = self.navigationController?.popToRootViewController(animated: true)
    }
    // Assigning the values from user data to repective
    func updateUserInterface ( _ userData : TestData ) {
        coreDataUser = userData
        usernameLabel.text = userData.username
        likesSwitch.isOn = userData.likes_javascript == 1
        ageText.text = String(userData.age)
        heightText.text = String(userData.height)
        magicHashLabel.text = userData.magic_hash
        magicNumberLabel.text = String(userData.magic_number)
        heightLabel.text = userData.feetInchesString
        ageLabel.text = userData.millisString
    }
    
    //core data is there right away but will take sometime to get the updated date from the server
    //everytime the api manager recieves new data it post a noti and once it is recieved ui can be updated 
    @objc func userDataReceived ( _ notification : Notification ) {
        
        if let userData = notification.object as? TestData {
            updateUserInterface(userData)
        }
        
    }
    
}
