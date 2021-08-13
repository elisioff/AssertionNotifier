# AssertionNotifier

[![CI Status](https://img.shields.io/travis/elisioff/AssertionNotifier.svg?style=flat)](https://travis-ci.org/elisioff/AssertionNotifier)
[![Version](https://img.shields.io/cocoapods/v/AssertionNotifier.svg?style=flat)](https://cocoapods.org/pods/AssertionNotifier)
[![License](https://img.shields.io/cocoapods/l/AssertionNotifier.svg?style=flat)](https://cocoapods.org/pods/AssertionNotifier)
[![Platform](https://img.shields.io/cocoapods/p/AssertionNotifier.svg?style=flat)](https://cocoapods.org/pods/AssertionNotifier)


Before a release we may have _debug_, _in-house_, _release-candidate_, etc, builds of our apps. In these builds we often leverage `assertionFailure(:)` which is great as it allows us to timely find and fix issues, the problem is when the assertion is hit and we have no idea what caused the crash because we **are not connected to Xcode**, hence AssertionNotifier.

## What it is
**AssertionNotifier** is a light weight `struct` that evaluates condition and reacts to the result. 

It wraps the condition for failure, evaluates it and in case of failure before terminating the app it schedules a notification to be sent with the information of the **file** and **line** where the issue originated.

It allows you to readily have an idea of the reason for the crash instead of having to look through you favorite crash reporting tool.

### Requirements
- iOS 13
- _10.14 (soon)_

## Installation
AssertionNotifier is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'AssertionNotifier'
```

---
**Author** _Elísio Fernandes_

## License
AssertionNotifier is available under the MIT license. See the LICENSE file for more info.
