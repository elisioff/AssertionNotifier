import XCTest
import AssertionNotifier

class NotificationsHandlerMock: AssertionMessenger {

    var didReceiveNotification = false

    func sendAssertNotification(message: String,
                                delay: TimeInterval,
                                file: StaticString,
                                line: UInt) {

        self.didReceiveNotification = true
    }
}

class Tests: XCTestCase {

    private var notificationsHandlerMock: NotificationsHandlerMock? = .init()

    override func setUp() {

        super.setUp()

        guard let notificationsHandlerMock = self.notificationsHandlerMock else { return }

        let assertionNotifierConfig = AssertionNotifier.Config(notificationsHandler: notificationsHandlerMock)
        AssertionNotifier.shared.configure(with: assertionNotifierConfig)
    }

    override func tearDown() {

        self.notificationsHandlerMock = nil

        super.tearDown()
    }

    func testAssertionNotifierDidNotSendNotification() {

        AssertionNotifier.shared.assert(true) {

            XCTFail()
        }
    }

    func testAssertionNotifierDidSendNotification() {

        AssertionNotifier.shared.assert(false) {

            XCTAssertTrue(self.notificationsHandlerMock?.didReceiveNotification ?? false)
        }
    }
}
