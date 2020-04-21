//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(updateStudentsInfromation(_:)), name: Notification.Name(rawValue: "updateStudentsInfromation"), object: nil)
        setupMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func updateStudentsInfromation(_ notification: Notification) {
        print("NOTIFICATION WORKED")
    }
    
    // MARK: Extract the information for every student and show it on the map
    func setupMap(){
        print("HEREEEE")
        var annotations = [MKPointAnnotation]()
        
        for student in StudentsInformation.data {
            let lat = CLLocationDegrees(student.latitude as! Double)
            let long = CLLocationDegrees(student.longitude as! Double)
            
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
        print(annotations.count)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("HERE2")
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
            
            guard let urlString = view.annotation?.subtitle! else{return}
            guard let url = URL(string: urlString) else{return}
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
