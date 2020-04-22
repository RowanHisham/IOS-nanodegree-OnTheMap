//
//  ViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/20/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: Authenticate Login
    @IBAction func login(_ sender: Any) {
        setLogginIn(true)
        let userData = LoginData(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        UdacityClient.login(userData: userData, completion: handleLogin(registered:error:))
    }
    
    // MARK: If Correct Credintails Login
    func handleLogin(registered: Bool, error: Error?){
        setLogginIn(false)
        guard error == nil, registered == true
            else {
                showError(message: error?.localizedDescription ?? "Error")
                return
            }
        
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    // MARK: Display Error Messages to the User
    func showError(message: String){
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}

