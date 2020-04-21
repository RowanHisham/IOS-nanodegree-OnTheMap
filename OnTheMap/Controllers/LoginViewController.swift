//
//  ViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/20/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

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
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = true
        // Triggers preferredStatusBarStyle to make StatusBar Light
        setNeedsStatusBarAppearanceUpdate()
        
        // Change corners to be round
        emailTextField.layer.cornerRadius = 25
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.masksToBounds = true
        
        passwordTextField.layer.cornerRadius = 25
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.masksToBounds = true
        
        loginButton.layer.cornerRadius = 25
        loginButton.layer.borderWidth = 2.0
        loginButton.layer.masksToBounds = true
        
        // Add Padding to the left and right of the text
        emailTextField.setPaddingPoints(15)
        passwordTextField.setPaddingPoints(15)
    }
    
    // MARK: Hides KeyBoard after Returning from Editing Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    // MARK: Set Status Bar Color to White
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func login(_ sender: Any) {
        setLogginIn(true)
        let userData = LoginData(username: emailTextField.text ?? "", password: passwordTextField.text ?? "")
        UdacityClient.login(userData: userData, completion: handleLogin(registered:error:))
    }
    
    func handleLogin(registered: Bool, error: Error?){
        setLogginIn(false)
        guard error == nil, registered == true
            else {
                showError(message: error?.localizedDescription ?? "Error")
                return
            }
        
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    func showError(message: String){
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func setLogginIn(_ loggingIn: Bool){
        if loggingIn{
            activityIndicator.startAnimating()
            emailTextField.isEnabled = false
            passwordTextField.isEnabled = false
            loginButton.isEnabled = false
            loginButton.alpha = 0.5
        }else{
            activityIndicator.stopAnimating()
            emailTextField.isEnabled = true
            passwordTextField.isEnabled = true
            loginButton.isEnabled = true
            loginButton.alpha = 1.0
        }
    }
}

