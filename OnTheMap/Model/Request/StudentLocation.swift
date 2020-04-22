//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/22/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

struct StudentLocation: Codable{
    // Singlton Instance to save current Student Location
    static var instance: StudentLocation? = nil
    
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Float
    var longitude:Float
}
