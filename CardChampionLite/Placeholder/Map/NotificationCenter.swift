//
//  NotificationCenter.swift
//  Placeholder
//
//  Created by Jonas Brockmöller on 25.04.22.
//

import Foundation
import UserNotifications

/*
 Tutorial used: https://www.raywenderlich.com/20690666-location-notifications-with-unlocationnotificationtrigger
 */

class NotifcationCenterModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // 1B
    override init() {
      super.init()
      // 2
      notificationCenter.delegate = self
    }
    
    private func makeCardDropRegion() -> CLCircularRegion {
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 51.353547, longitude: 6.1535209), radius: 10, identifier: UUID().uuidString)
      region.notifyOnEntry = true
      return region
    }
    
    // 1
    func requestNotificationAuthorization() {
        // 2
        let options: UNAuthorizationOptions = [.sound, .alert]
        // 3
        notificationCenter
            .requestAuthorization(options: options) { [weak self] result, _ in
                // 4
                print("Notification Auth Request result: \(result)")
                /*
                 This code tests the authorization result to see if the user has given permission to receive notifications. If so, register the region trigger notification.
                 */
                if result {
                  self?.registerNotification()
                }
            }
    }
    /*
     The code above does the following:
     1.Creates a method to request notification authorization.
     2.Defines the notification’s capabilities and requests the ability to play sounds and display alerts.
     3.Requests authorization from the user to show local notifications.
     4.The completion block prints the results of the authorization request to the debugger.
     */
    
    // 1
    private func registerNotification() {
        // 2
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "CardDrop found nearby"
        notificationContent.body = "Stop here to unlock new cards"
        notificationContent.sound = .default
        
        // 3
        let trigger = UNLocationNotificationTrigger(region: makeCardDropRegion(), repeats: false)
        
        // 4
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: trigger)
        
        // 5
        notificationCenter
            .add(request) { error in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            }
    }
    /*
     This method does the following:
     1.Creates a method to register a notification.
     2.Creates content for a notification. UNMutableNotificationContent is the object used for representing the content of a notification. Here, you’re setting the title, body and sound properties of this object.
     3.Creates a location trigger condition that causes the notification to appear. This gets triggered when you enter the storeRegion.
     4.Configures a UNNotificationRequest object to request a notification with the notificationContent and trigger. A unique identifier is set in this request. This is useful if you need to cancel a notification.
     5.Adds the request to schedule the notification.
     */
    
    // 1
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      // 2
      print("Received Notification")
      // 3
      completionHandler()
    }

    // 4
    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      willPresent notification: UNNotification,
      withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
      // 5
      print("Received Notification in Foreground")
      // 6
      completionHandler(.sound)
    }
    /*
     Here’s an overview of the code:
     1.This delegate method will be called if the user taps on the notification.
     2.Prints to the debugger when you receive a notification.
     3.Tells the system you finished handling the notification.
     4.This delegate method handles a notification that arrives when the app is in the foreground.
     5.Prints to the debugger when you receive a notification in the foreground.
     6.Tells the system that you’ve finished handling the foreground notification and it should only play a notification sound, not display the notification.
     */
}
