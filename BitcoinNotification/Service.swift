//
//  Service.swift
//  BitcoinNotification
//
//  Created by Miguel Mexicano on 28/02/18.
//  Copyright © 2018 Miguel Mexicano. All rights reserved.
//

import UIKit

class Service: NSObject {
    
    
    
    func buyBitcoin(completionHandler: @escaping (Bool,Error?) -> ()) {
        
        RestUtil.restGet(url: EndPoints.bitcoin) { (response, error) in
            
            //print("Service: ",response!)
           let payload = response!["payload"]
           let strprice = payload!["last"] as! String
            
            //let price:String = response!["low"] as! String
            
           let price = Double(strprice)
            print(price!)
            
            if(price! >= 207000.00){
                //vender
                print("vender")
                completionHandler(false,nil)
            }else{
                print("comprar")
                completionHandler(true,nil)
            }
        }

    }
    

}
