//
//  ImageSourceView
//
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//


import Cocoa

class ImageSourceView: RoundedRectView {
  
  override func mouseDown(with event: NSEvent) {
    let pasteboardItem = NSPasteboardItem()
    pasteboardItem.setDataProvider(self, forTypes: [kUTTypeTIFF])
    
    let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
    draggingItem.setDraggingFrame(self.bounds, contents:snapshot())
    
    beginDraggingSession(with: [draggingItem], event: event, source: self)
  }
}

// MARK: - NSDraggingSource
extension ImageSourceView: NSDraggingSource {
  func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
    return .generic
  }
  
}
// MARK: - NSPasteboardItemDataProvider
extension ImageSourceView: NSPasteboardItemDataProvider {
  func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type: String) {
    if let pasteboard = pasteboard, type == String(kUTTypeTIFF), let image = NSImage(named: "unicorn") {
      let finalImage = image.tintedImageWithColor(NSColor.randomColor())
      
      let tiffdata = finalImage.tiffRepresentation
      pasteboard.setData(tiffdata, forType: type) // 图片转为TIFF数据，并放置到粘贴板上
    }
  }
}
