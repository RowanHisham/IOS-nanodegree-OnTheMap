//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       subscribe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @objc func updateStudentsInfromation(_ notification: Notification) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Set number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsInformation.data.count
    }
    
    // MARK: fill cell with image and text
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")!
        cell.textLabel?.text = StudentsInformation.data[indexPath.row].firstName +  StudentsInformation.data[indexPath.row].lastName
        
        // Set cell image color to blue
        cell.imageView?.image = cell.imageView?.image?.withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .appleBlue()

        return cell
    }
    
    //Open student's MediaURL when row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: StudentsInformation.data[indexPath.row].mediaURL)else
        {   showError()
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            guard success == true else{
                self.showError()
                return
            }
        }
    }
    
    func showError(){
        let alertController = UIAlertController(title: "Can't Open URL", message: "URL not valid or student did not provide it", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    func subscribe(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentsInfromation(_:)), name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unsubscribe(_:)), name: Notification.Name(rawValue: "logout"), object: nil)
    }
    
    @objc func unsubscribe(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"updateStudentsInfromation"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"logout"), object: nil)
    }
}
