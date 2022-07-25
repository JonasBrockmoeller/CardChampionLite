//
//  PlaceholderApp.swift
//  Placeholder
//
//  Created by Tim Weigand on 24.03.22.
//
/*
 PUSHER NOTIFICATION SIMULATOR SETTINGS:
 Key_ID: 5NJTHG8YS3
 Team_ID: KH7BD93PMV
 Bundle_ID: nl.fontys.prj42204.WenderCast
 Token: See phone output...
 */
import SwiftUI
import Foundation

@main
struct PlaceholderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var purchaseModel: InAppPurchaseModel
    
    init(){
        self._purchaseModel = StateObject(wrappedValue: InAppPurchaseModel())
        self.requestAccessToNotifications()
    }
    
    var body: some Scene {
        WindowGroup{
            //try to login here
            //if successfull open this
            //LoadingView()
            //else open loginView
            LoadingView()
                .environmentObject(purchaseModel)
        }
    }
    
    func requestAccessToNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [self] granted, _ in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self.registerForRemoteNotificationsWithAPN()
                }
    }
    
    func registerForRemoteNotificationsWithAPN() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: "APN-Token")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
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
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
