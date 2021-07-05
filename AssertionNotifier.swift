//
//  AssertionNotifier.swift
//  AssertionNotifier
//
//  Created by Elisio Freitas Fernandes on 10/05/2021.
//  Copyright (c) 2021 Elísio Fernandes
//  MIT license, see LICENSE file for details
//

import Foundation
import os.log

public struct AssertionNotifier {

    public struct Config {

        weak var notificationsMessenger: AssertionMessenger?

        public init(notification: AssertionMessenger) {

            self.notificationsMessenger = notification
        }
    }

    public static var shared = AssertionNotifier()

    var config: AssertionNotifier.Config?

    public mutating func configure(with config: Self.Config) {

        self.config = config
    }

    static func assert(
        _ condition: @autoclosure () -> Bool,
        message: String = .init(),
        delay: TimeInterval = 3,
        file: StaticString = #file,
        line: UInt = #line
    ) {

        #if DEBUG
        if condition() == false,
           let notificationsMessenger = AssertionNotifier.shared.config?.notificationsMessenger {

            notificationsMessenger.sendAssertNotification(message: message,
                                                          delay: delay,
                                                          file: file,
                                                          line: line)

            os_log(.error, "%@", message)
            assertionFailure(message, file: file, line: line)
        }
        #endif
    }
}

public protocol AssertionMessenger: AnyObject {
    
    func sendAssertNotification(message: String,
                                delay: TimeInterval,
                                file: StaticString,
                                line: UInt)
}
