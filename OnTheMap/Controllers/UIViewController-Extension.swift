//
//  UIViewController-Extension.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/23/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    // MARK: Display Error Message to the User
    func showError(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
