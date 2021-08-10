//
//  NotificationManager.swift
//  Healco
//
//  Created by Kelny Tan on 09/08/21.
//

import Foundation
import UIKit
import UserNotifications

extension UIViewController: UNUserNotificationCenterDelegate{
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }
}
