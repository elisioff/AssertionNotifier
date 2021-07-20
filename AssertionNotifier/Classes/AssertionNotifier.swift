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

public struct AssertionNotifier {

    public struct Config {

        weak var notificationsHandler: AssertionMessenger?

        public init(notificationsHandler: AssertionMessenger) {

            self.notificationsHandler = notificationsHandler
        }
    }

    public static var shared = AssertionNotifier()

    private var config: AssertionNotifier.Config?

    public mutating func configure(with config: Self.Config) {

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
                                        closure: nil)
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

public protocol AssertionMessenger: AnyObject {
    
    func sendAssertNotification(message: String,
                                delay: TimeInterval,
                                file: StaticString,
                                line: UInt)
}

