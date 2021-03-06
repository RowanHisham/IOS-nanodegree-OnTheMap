//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

struct LoginRequest: Codable{
    let udacity: LoginData
}

struct LoginData: Codable{
    let username: String
    let password: String
}
