//
//  ViewController.swift
//  BitcoinNotification
//
//  Created by Miguel Mexicano on 28/02/18.
//  Copyright © 2018 Miguel Mexicano. All rights reserved.
//

import UIKit
import  UserNotifications
import UserNotificationsUI

class ViewController: UIViewController {
    let requestIdentifier = "SampleRequest"
    let service = Service()
    var updateTimer:Timer?
    let tiempo = 1
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reinstateBackgroundTask), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.serviceBuyBitcoin()
        
       
                //your main thread
                self.updateTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(self.tiempo), repeats: true, block: { (timer) in
                    self.serviceBuyBitcoin()
                })
        
        
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @objc func reinstateBackgroundTask() {
        if updateTimer != nil && (backgroundTask == UIBackgroundTaskInvalid) {
            registerBackgroundTask()
        }
    }
    
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    func serviceBuyBitcoin() {
        self.service.buyBitcoin { (resp, error) in
            if(resp){
                self.sendPush(title: "Bitso", subtitle: "Compra bitcoin", body: "Es hora de comprar")
                
            }else{
               self.sendPush(title: "Vender", subtitle: "Vender bitcoin", body: "Es hora de vender")
            }
            
            switch UIApplication.shared.applicationState {
            case .active:
                print("App is active")
            case .background:
                print("App is backgrounded")
                print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
            case .inactive:
                break
            }
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
    }

    @IBAction func sendPush(_ sender: Any) {
        self.sendPush(title: "Bitcoint",subtitle: "Comprar o Vender", body: "Comparar o vender")
    }


    
    
    //Enviar Notificacion Push
    func sendPush(title: String, subtitle:String, body: String){
        print("la notificacion se mostrara en 1 segundo")
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "Image", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("recurso no encontrado")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content,trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription ?? "")
            }
        }
    }
}




extension ViewController:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

