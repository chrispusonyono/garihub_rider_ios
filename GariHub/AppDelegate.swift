//
//  AppDelegate.swift
//  GariHub
//
//  Created by Kevin Lagat on 18/09/2020.
//  Copyright © 2020 Kevin Lagat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

let API_KEY = "AIzaSyDy4XgOiSH1w6F6Nt92CvU3cRjYtWiJjT4"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var router: AppCoordinator!
    var locationManager = LocationManager()
    let gcmMessageIDKey = "gcm.message_id"

    

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        GMSServices.provideAPIKey("AIzaSyDy4XgOiSH1w6F6Nt92CvU3cRjYtWiJjT4")
        GMSPlacesClient.provideAPIKey("AIzaSyDy4XgOiSH1w6F6Nt92CvU3cRjYtWiJjT4")
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        let campaign = CampaignController()
        window?.rootViewController = campaign
        window?.makeKeyAndVisible()
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in})
            
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        self.router = .init()
        self.router.setRoot(for: self.window ?? .init(frame: UIScreen.main.bounds))
        
        
        return true
    }
    
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //Receive displayed notification for iOS devices
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        completionHandler([[.alert, .sound]])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        completionHandler()
    }
    
}

extension AppDelegate: MessagingDelegate {

    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
          }
        }
        print("Firebase resgistration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
}
