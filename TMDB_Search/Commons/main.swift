//
//  main.swift
//  TMDB_Search
//
//  Created by Pierre jonny cau on 24/07/2018.
//  Copyright © 2018 Pierre Jonny Cau. All rights reserved.
//

import UIKit
import Foundation

class FakeAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {

        return true
    }
}
//Change AppDelegate for testing
let isRunningTests = NSClassFromString("XCTestCase") != nil
let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
if isRunningTests {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(FakeAppDelegate.self))
} else {
    UIApplicationMain(CommandLine.argc, args, nil, NSStringFromClass(AppDelegate.self))
}
