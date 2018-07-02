//
//  RoundedRectView
//
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//

import Cocoa

@IBDesignable class RoundedRectView: NSView {
  
  let radius: CGFloat = 10.0
  
  override func draw(_ dirtyRect: NSRect) {
    
    let path = NSBezierPath(roundedRect: NSInsetRect(bounds, radius, radius), xRadius: radius, yRadius: radius)
    NSColor.white.set()
    path.fill()
    
  }
  
}
