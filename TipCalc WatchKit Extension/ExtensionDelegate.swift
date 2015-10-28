//
//  ExtensionDelegate.swift
//  TipCalc WatchKit Extension
//
//  Created by Sheng Yu on 10/2/15.
//  Copyright © 2015 Sheng Yu. All rights reserved.
//

import WatchKit
import ClockKit
//import XCGLogger

let log = XCGLogger.defaultInstance()

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: false, showLineNumbers: true, writeToFile: nil, fileLogLevel: .Debug)
        
        // Perform any final initialization of your application.
        log.debug("")
        
        
//        let complicationServer = CLKComplicationServer.sharedInstance()
//        if complicationServer.activeComplications == nil {
//            print("no activeComplications")
//            return
//        }
//        
//        for complication in complicationServer.activeComplications {
//            complicationServer.reloadTimelineForComplication(complication)
//        }
    }

    func applicationDidBecomeActive() {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        log.debug("applicationDidBecomeActive")
    }

    func applicationWillResignActive() {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, etc.
        log.debug("applicationWillResignActive")
    }

}
