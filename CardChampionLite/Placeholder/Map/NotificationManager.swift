//
//  NotificationManager.swift
//  WenderCast
//
//  Created by Jonas Brockmöller on 25.04.22.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    override init(){
        super.init()
        // set UNUserNotificationCenter delegate to self
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestNotificationServiceAuthorization(){
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("notifications are authorized")
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        print("Got authorization")
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    func postTriggeredNotification(region: CLRegion){
        let content = UNMutableNotificationContent()
        content.title = "CardDrop Nearby"
        content.subtitle = "Open the App now to get a new card!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        completionHandler([[.list, .banner], .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
}
