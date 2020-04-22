//
//  AddPinViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/22/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit

class AddPinViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var placeTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    var placeSelected: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        placeTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Hides KeyBoard after Returning from Editing Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func configureUI(){
        // Change corners to be round
        placeTextField.layer.cornerRadius = 25
        placeTextField.layer.borderWidth = 2.0
        placeTextField.layer.masksToBounds = true
        placeTextField.layer.borderColor =  UIColor(white: 1.0, alpha: 0).cgColor
        placeTextField.layer.backgroundColor =  UIColor(white: 0, alpha: 0.2).cgColor

        
        addButton.layer.cornerRadius = 25
        addButton.layer.borderWidth = 2.0
        addButton.layer.masksToBounds = true
        addButton.layer.borderColor =  UIColor(white: 1.0, alpha: 0).cgColor
        
        placeTextField.setPaddingPoints(15)
    }

    // MARK: Save entered Text and return to MapViewController
    @IBAction func returnToTabController(_ sender: Any) {
        placeSelected = placeTextField.text ?? ""
        self.performSegue(withIdentifier: "unwindToTabController", sender: self)
    }
}
