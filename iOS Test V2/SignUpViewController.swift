//
//  SignUpViewController.swift
//  iOS Test V2
//
//  Created by Miti Shah on 7/10/18.
//  Copyright © 2018 Miti Shah. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
   
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var pwText: UITextField!
    @IBOutlet weak var confirmPWText: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func signup(_ sender: UIButton) {
        if let user = userText.text, let pw = pwText.text, let conpw = confirmPWText.text, user.isEmpty == false, pw.isEmpty == false, conpw.isEmpty == false, pw == conpw {
            MainPresenter.shared.signUp(user, pw) { success, message in
                if success {
                    self.performSegue(withIdentifier: "signUpAcc", sender: nil)
                    print("Success")
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "There was an error signing up.\n\n\(message)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Sign Up", message: "Please verify your credentials", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
