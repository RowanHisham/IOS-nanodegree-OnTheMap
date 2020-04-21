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
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentsInfromation(_:)), name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    @objc func updateStudentsInfromation(_ notification: Notification) {
        tableView.reloadData()
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
        guard let url = URL(string: StudentsInformation.data[indexPath.row].mediaURL)else {return}
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
}
