//
//  MapViewController-Extension.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/22/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import MapKit

extension MapViewController: MKMapViewDelegate, UITextFieldDelegate{

    func configureUI(){
        urlView.isHidden = true
        // Change corners to be round
        urlTextField.layer.cornerRadius = 25
        urlTextField.layer.borderWidth = 2.0
        urlTextField.layer.masksToBounds = true
        urlTextField.layer.borderColor =  UIColor(white: 1.0, alpha: 0).cgColor
        urlTextField.layer.backgroundColor =  UIColor(white: 0, alpha: 0.2).cgColor
        
        
        confirmUrlButton.layer.cornerRadius = 25
        confirmUrlButton.layer.borderWidth = 2.0
        confirmUrlButton.layer.masksToBounds = true
        confirmUrlButton.layer.borderColor =  UIColor(white: 1.0, alpha: 0).cgColor
        
        urlTextField.setPaddingPoints(15)
    }
    
    // MARK: Hides KeyBoard after Returning from Editing Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // MARK: Disable Navigationbar and Tabbar when waiting for the user to enter URL
    func enteringURL(_ state: Bool){
        if state{
            self.urlView.isHidden = false
            navigationController?.isNavigationBarHidden = true
            tabBarController?.tabBar.isHidden = true
            
        }else{
            self.urlView.isHidden = true
            navigationController?.isNavigationBarHidden = false
            tabBarController?.tabBar.isHidden = false;
            
        }
    }
    
    // MARK: Subscribe to tabController notifications
    func subscribe(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentsInfromation(_:)), name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unsubscribe(_:)), name: Notification.Name(rawValue: "logout"), object: nil)
    }
    
    // MARK: Unsubscribe to tabController notifications
    @objc func unsubscribe(_ notification: Notification){
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"updateStudentsInfromation"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"logout"), object: nil)
    }
    
    // MARK: Update User Student Information on the Map
    @objc func updateStudentsInfromation(_ notification: Notification) {
        setupMap()
        self.mapView.reloadInputViews()
    }
    
    // MARK: Extract the information for every student and update annotation list
    func setupMap(){
        var annotations = [MKPointAnnotation]()
        
        for student in StudentsInformation.data {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            //create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // append the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    // MARK: Update and Display PinMarker
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    // Open MediaURL in default browser when pinAnnotationView tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            guard let urlString = view.annotation?.subtitle!, let url = URL(string: urlString) else{
                showError(title: "Error", message: "URL not valid or student did not provide it")
                return
            }
            
            UIApplication.shared.open(url, options: [:]) { success in
                guard success == true else{
                    self.showError(title: "Error", message: "URL not valid or student did not provide it")
                    return
                }
            }
        }
    }
    
}
