//
//  TabViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        // Load Student Information Only Once when the User Login
        if( StudentsInformation.data.isEmpty){
            loadStudentInformation()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = false
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        
        let addBarButtonItem = UIBarButtonItem(image: UIImage(named: "pin.png"), style:.plain, target: self, action:  #selector(addMarker))
        
        
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.leftBarButtonItem = addBarButtonItem
        self.navigationItem.title = "On The Map"
    }
    
    // MARK: Load Random Student Information to Populate the Map and TableView
    func loadStudentInformation(){
        UdacityClient.getStudentsInformation(completion: handleStudentsInformation)
    }

    // MARK: Notify user if error occured
    func handleStudentsInformation(error: Error?){
        guard error == nil else{
            showError(message: error?.localizedDescription ?? "Error")
            return
        }
        
        //Post a Notification that the StudentInfromation Array has been updated so observers can take requried actions accordingly
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)
    }
    
    @objc func logout(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        UdacityClient.logout(completion: handlelogout)
    }
    
    // MARK: Return to login screen
    func handlelogout(){
        // Empty the student Infromation list
        StudentsInformation.data = []
        //Post a Notification that the app is logging out so observers can unsubscribe
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    // MARK: Display AddPin ViewController
    @objc func addMarker(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: "logout"), object: nil)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addPin") as! AddPinViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: Display Error Messages to the User
    func showError(message: String){
        let alertController = UIAlertController(title: "Fetching Students Information Failed", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Reload", style: .default) { alertAction in
            self.loadStudentInformation()
        }
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
