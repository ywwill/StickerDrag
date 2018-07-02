//
//  AppDelegate
//
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

}

