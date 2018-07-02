//
//  AppActionSourceView
//
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//

import Cocoa

enum SparkleDrag {
  static let type = "com.hades.StickerDrag.AppAction"
  static let action = "make sparkles"
}

class AppActionSourceView: RoundedRectView {
  
  override func mouseDown(with theEvent: NSEvent) {
    
    let pasteboardItem = NSPasteboardItem()
    pasteboardItem.setString(SparkleDrag.action, forType: SparkleDrag.type)
    let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
    draggingItem.setDraggingFrame(self.bounds, contents:snapshot())
    
    beginDraggingSession(with: [draggingItem], event: theEvent, source: self)
  }
}

// MARK: - NSDraggingSource
extension AppActionSourceView: NSDraggingSource {
  
  func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor
    context: NSDraggingContext) -> NSDragOperation {
    
    switch(context) {
    case .outsideApplication:
      return NSDragOperation()
    case .withinApplication:
      return .generic
    }
  }
}
