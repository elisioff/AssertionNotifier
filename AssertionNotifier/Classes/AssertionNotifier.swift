//
//  AssertionNotifier.swift
//  AssertionNotifier
//
//  Created by Elísio Freitas Fernandes on 10/05/2021.
//  Copyright (c) 2021 Elísio Fernandes
//  MIT license, see LICENSE file for details
//

import Foundation
import os.log

public class AssertionNotifier {

    /// Configuration structure to provided AssertionNotifier with the required elements to work properly.
    public struct Config {

        /// Object that will handle the notifications AssertionNotifier creates, without which no notification can be delivered.
        weak var notificationsHandler: AssertionMessenger?

        public init(notificationsHandler: AssertionMessenger) {

            self.notificationsHandler = notificationsHandler
        }
    }

    /// Shared instance of AssertionNotifier. Do not forget to call `configure(with:)` in order to provide
    /// this instance with the required elements for it to be able to notify the need to send a notification.
    public static var shared = AssertionNotifier()

    private var config: AssertionNotifier.Config?

    /// Configures the instance so that it has an AssertionMessenger to which it can hand over notifications.
    /// - Parameter config: AssertionNotifier.Config with the desired elements
    public func configure(with config: AssertionNotifier.Config) {

        self.config = config
    }
    
    /// Validates condition, in case of true sends notification to `AssertionMessenger`provided, runs closure and asserts.
    /// - Parameters:
    ///   - condition: Condition to be validated, which in case of `true` leads to assertion.
    ///   - message: Message to be passed to the `AssertionMessenger` provided in the `configure(with:)`.
    ///   - delay: Delay between assertion and receiving a notification. Default value of 3 seconds.
    ///   - file: File name where the assertion originated.
    ///   - line: Line number where assertion originated.
    public func assert(
        _ condition: @autoclosure () -> Bool,
        message: String = .init(),
        delay: TimeInterval = 3,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        AssertionNotifier.shared.assert(condition(),
                                        message: message,
                                        delay: delay,
                                        closure: nil,
                                        file: file,
                                        line: line)
    }
}

// MARK: - Internal
extension AssertionNotifier {

    /// For Unit Testing purposes. Validates condition, in case of true sends notification to `AssertionMessenger`provided, runs closure and asserts.
    /// - Parameters:
    ///   - condition: Condition to be validated, which in case of `true` leads to assertion.
    ///   - message: Message to be passed to the `AssertionMessenger` provided in the `configure(with:)`.
    ///   - delay: Delay between assertion and receiving a notification. Default value of 3 seconds.
    ///   - closure: Optional closure with operations to be run immediately before assertion.
    ///   - file: File name where the assertion originated.
    ///   - line: Line number where assertion originated.
    func assert(
        _ condition: @autoclosure () -> Bool,
        message: String = .init(),
        delay: TimeInterval = 3,
        closure: (() -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        #if DEBUG
        if !condition() {

            self.config?.notificationsHandler?.sendAssertNotification(message: message,
                                                                     delay: delay,
                                                                     file: file,
                                                                     line: line)

            guard closure == nil else {

                closure?()
                return
            }
            os_log(.error, "%@", message)

            assertionFailure(message, file: file, line: line)
        }
        #endif
    }
}

/// A notification handler. This object is **required** in order to have the ability to **send notifications** to the notification center.
/// You may already have your own handler, just conform to this and make it send a notification with the format that best
/// suits your needs.
///
/// In your notification handler you can add something like the following example in order to have it working with little effort.
/// ```swift
/// func sendAssertNotification(message: String,
///                             delay: TimeInterval,
///                             file: StaticString = #file,
///                             line: UInt = #line) {
///
///     let notificationContent = UNMutableNotificationContent()
///     notificationContent.title = Constants.title
///     notificationContent.subtitle = message
///     notificationContent.body = """
///                           \(message)
///                           In file: \(file.description)
///                           At line: \(line.description)
///                           """
///
///     let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delay,
///                                                                 repeats: false)
///
///     let notificationRequest = UNNotificationRequest(identifier: "assertionFailureHit",
///                                                     content: notificationContent,
///                                                     trigger: notificationTrigger)
///
///     UNUserNotificationCenter.current().add(notificationRequest)
/// }
/// ```
public protocol AssertionMessenger: AnyObject {
    
    func sendAssertNotification(message: String,
                                delay: TimeInterval,
                                file: StaticString,
                                line: UInt)
}

