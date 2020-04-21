//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Rowan Hisham on 4/21/20.
//  Copyright © 2020 Rowan Hisham. All rights reserved.
//

import Foundation

class UdacityClient{
    
    enum Endpoints{
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSessionId
        case deleteSession
        case getUserData
        case getStudentsInforamtion
        
        var stringValue: String{
            switch self{
            case .createSessionId, .deleteSession: return Endpoints.base + "/session"
            case .getUserData: return Endpoints.base + "/users/\(Auth.accountId)"
            case .getStudentsInforamtion: return Endpoints.base + "/StudentLocation?order=-updatedAt"
            }
        }
        
        var url: URL{
            return URL(string: stringValue)!
        }
    }
    
    struct Auth {
        static var accountId = ""
        static var sessionId = ""
    }
    
    class func login(userData: LoginData, completion: @escaping (Bool, Error?)->Void){
        
        var request = URLRequest(url: Endpoints.createSessionId.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a Codable struct
        let encoder = JSONEncoder()
        let body = try! encoder.encode(LoginRequest(udacity: userData))
        request.httpBody = body
        ///////////////////////////
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            do{
                let userData = try decoder.decode(LoginResponse.self, from: newData)
                Auth.accountId = userData.account.key
                Auth.sessionId = userData.session.id
                
                DispatchQueue.main.async {
                    completion(userData.account.registered,nil)
                }
            }catch{
                do{
                    let error = try decoder.decode(ErrorResponse.self, from: newData)
                    DispatchQueue.main.async {
                        completion(false,error)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completion(false,error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    class func logout(completion: @escaping () -> Void){
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion()
            }
        }
        task.resume()
    }
    
    class func getUserData(completion: @escaping (UserData, Error?)-> Void){
        var request = URLRequest(url: Endpoints.getUserData.url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else{return}
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            do{
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserData.self, from: newData)
                print(userData)
                completion(userData, nil)
            }catch{
            }
        }
        task.resume()
    }
    
    class func getStudentsInformation(completion: @escaping (Error?)->Void){
        let request = URLRequest(url: Endpoints.getStudentsInforamtion.url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        
            guard let data = data else{
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let studentsInfo = try decoder.decode(StudentsInfoResponse.self, from: data)
                StudentsInformation.data = studentsInfo.results
                DispatchQueue.main.async {
                    completion(nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
        task.resume()
    }

}
