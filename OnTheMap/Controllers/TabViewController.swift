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
        UdacityClient.getStudentsInformation(completion: handleStudentsInformation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configureUI(){
        navigationController?.isNavigationBarHidden = false
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logout))
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(addMarker))
        
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.leftBarButtonItem = addBarButtonItem
        self.navigationItem.title = "On The Map"
        tabBarController?.tabBarItem.image = UIImage(named: "mapIcon.png")
    }
    
    @objc func logout(){
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        UdacityClient.logout(completion: handlelogout)
    }
    
    @objc func addMarker(){
        print("Here2")
        UdacityClient.getUserData(completion: handleUserData)
    }
    
    func handlelogout(){
        self.performSegue(withIdentifier: "logout", sender: self)
    }
    
    func handleUserData(userData: UserData, error: Error?){
        print(userData.firstName)
        print(userData.lastName)
    }
    
    func handleStudentsInformation(error: Error?){
        guard error == nil else{
            showError(message: error?.localizedDescription ?? "Error")
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)
    }
    
    func showError(message: String){
        let alertController = UIAlertController(title: "Fetching Students Information Failed", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
