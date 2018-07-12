//
//  SignInViewController.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController  {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func anyTextChanged ( _ sender : UITextField ) {
        loginButton.isEnabled = (userText.text ?? "").isEmpty == false && (pwText.text ?? "").isEmpty == false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.isEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func login(_ sender: UIButton) {
        if let user = userText.text, let pw = pwText.text, user.isEmpty == false, pw.isEmpty == false {
            MainPresenter.shared.login(user, pw) { success, message in
                if success {
                    self.performSegue(withIdentifier: "signInAcc", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "There was an error signing in.\n\n\(message)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
