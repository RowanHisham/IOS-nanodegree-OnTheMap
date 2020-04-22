//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var urlView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var confirmUrlButton: UIButton!
    
    var newAnnotation = MKPointAnnotation()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        self.mapView.removeAnnotations(self.mapView.annotations)
        mapView.delegate = self
        urlTextField.delegate = self
        subscribe()
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    // MARK: Unwind Segue Triggered when user return from AddPinViewController
    @IBAction func unwindToTab(unwindSegue: UIStoryboardSegue) {
        if let addPinViewController = unwindSegue.source as? AddPinViewController {
            // Update the Current Student Location Instance
            StudentLocation.instance = StudentLocation.init(uniqueKey: "", firstName: "", lastName: "", mapString: addPinViewController.placeSelected, mediaURL: "", latitude: 0, longitude: 0)
            
            self.showLocationOnMap()
        }
    }
    
    // MARK: Check if location is valid and zoom in on it
    func showLocationOnMap(){
        // MARK: Geocode the Location user entered
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = StudentLocation.instance?.mapString
        let search = MKLocalSearch(request: searchRequest)
        
        // If it doesn't exist display an error message
        search.start { response, error in
            guard let response = response else {
                self.showError(message: "Can't Find Location")
                return
            }
            
            
        for item in response.mapItems {
            if let mi = item as? MKMapItem {
                // zoom in on the location
                let span = MKCoordinateSpan(latitudeDelta: 0.9000, longitudeDelta: 0.9000)
                let coordinate = mi.placemark.location?.coordinate
                let region = MKCoordinateRegion(center: coordinate!, span: span)
                self.mapView.setRegion(region, animated: true)
                
                // Update the Student Location Instance with the coordinates
                StudentLocation.instance?.longitude = Float(coordinate!.longitude)
                StudentLocation.instance?.latitude = Float(coordinate!.latitude)
                
                // Show a new PinMarker on the Map
                self.newAnnotation.coordinate = coordinate!
                self.mapView.addAnnotation(self.newAnnotation)
                
                // Retrieve student infromation [ FirstName, LastName ]
                UdacityClient.getUserData(completion: self.handleUserData)
                break
                }
            }
        }
    }
    
    // MARK: If the student information can't be found ignore posting the new Pin Location
    func handleUserData(userData: UserData?, error: Error?){
        guard error == nil else{
            showError(message: "Can't retrieve account information")
            return
        }
        
        StudentLocation.instance?.firstName = userData!.firstName
        StudentLocation.instance?.lastName = userData!.lastName
        
        // Disable Navigationbar and Tabbar when waiting for the user to enter URL
        enteringURL(true)
    }
    
    // MARK: Save the URL and POST the New Student Location
    @IBAction func enteredURL(_ sender: Any) {
        // Enable Navigationbar and Tabbar
        enteringURL(false)
        
        StudentLocation.instance?.mediaURL = urlTextField.text ?? ""
        
        UdacityClient.postStudentLocation(studentLocation: StudentLocation.instance!){ error in
            
            guard error == nil else{
                self.showError(message: "Can't Post New Location")
                return
            }
            
            
            // Display new PinMarker with the URL
            self.mapView.removeAnnotation(self.newAnnotation)
            self.newAnnotation.title = "\(StudentLocation.instance!.firstName) \(StudentLocation.instance!.lastName)"
            self.newAnnotation.subtitle = StudentLocation.instance!.mediaURL
            self.mapView.addAnnotation(self.newAnnotation)
        }
    }
    
    // MARK: Display Error Messages to the User
    func showError(message: String){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
}
