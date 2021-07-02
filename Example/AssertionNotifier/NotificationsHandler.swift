//
//  NotificationsHandler.swift
//  Demo Floor (iOS)
//
//  Created by Elisio Freitas Fernandes on 10/05/2021.
//

//
//  NotificationHandler.swift
//  PandaMinute (iOS)
//
//  Created by Elisio Freitas Fernandes on 15/09/2020.
//

import os.log
import SwiftUI
import UserNotifications
import AssertionNotifier

class NotificationsHandler: NSObject {

    enum Constants {

        static let title = "Assertion Failure".uppercased()
        static let body = """
                    %@
                    In file: %@
                    At line: %@
                    """
    }

    static let shared = NotificationsHandler()

    func requestNotificationsAuthorization(with application: UIApplication) {

        let autorizationOptions: UNAuthorizationOptions = [.alert, .sound]

        UNUserNotificationCenter.current().requestAuthorization(options: autorizationOptions) { granted, error in

            if let error = error {

                os_log(.debug, "%@", error.localizedDescription)
                return
            }

            os_log("Notifications allowed")
        }
    }
}

// MARK: AssertionMessenger

extension NotificationsHandler: AssertionMessenger {
    
    func sendAssertNotification(message: String,
                                delay: TimeInterval,
                                file: StaticString = #file,
                                line: UInt = #line) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Constants.title
        notificationContent.subtitle = message
        notificationContent.body = String(format: Constants.body, message, file.description, line.description)
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delay,
                                                                    repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: "assertionFailureHit",
                                                        content: notificationContent,
                                                        trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(notificationRequest)
    }
}
