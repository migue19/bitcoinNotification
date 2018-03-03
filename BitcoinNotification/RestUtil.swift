//
//  RestUtil.swift
//  URLSessionSwift
//
//  Created by Miguel Mexicano on 16/02/18.
//  Copyright © 2018 Miguel Mexicano. All rights reserved.
//

//          Identar IOS   The keyboard shortcuts are ⌘+] for indent and ⌘+[ for un-indent.



import UIKit

class RestUtil: NSObject {
    
    static func restGet(url: String,completionHandler: @escaping ([String : AnyObject]?,Error?) -> ()){
        let endpoint = url
        
        
        guard let endpointUrl = URL(string: endpoint) else {
            return
        }
        
        var request = URLRequest(url: endpointUrl)
        request.httpMethod = "GET"
        //request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data,respons,error in
            
            do {
                let result = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                completionHandler(result, nil)
            } catch {
                print("Error -> \(error)")
                return completionHandler(nil, error)
            }
        }
        
        task.resume()
        
    }
    
    
    
    
    
}
