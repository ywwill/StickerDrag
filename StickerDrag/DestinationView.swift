//
//  DestinationView
//
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//


import Cocoa

protocol DestinationViewDelegate {
  func processImageURLs(_ urls: [URL], center: NSPoint) // 图片url
  func processImage(_ image: NSImage, center: NSPoint)  // 图片
  func processAction(_ action: String, center: NSPoint) // 自定义类型
}

class DestinationView: NSView {
  
  enum Appearance {
    static let lineWidth: CGFloat = 10.0
  }
  
  var delegate: DestinationViewDelegate?
  
  override func awakeFromNib() {
    setup()
  }
  
  var nonURLTypes: Set<String> { return [String(kUTTypeTIFF), SparkleDrag.type] } // kUTTypeTIFF类型 + 自定义的SparkleDrag类型
  
  var acceptableTypes: Set<String> { return nonURLTypes.union([NSURLPboardType]) } //合并kUTTypeTIFF和URL类型
  
  func setup() {
    //接收URLs的拖拽数据
    register(forDraggedTypes: Array(acceptableTypes))
  }
  
  let filteringOptions = [NSPasteboardURLReadingContentsConformToTypesKey:NSImage.imageTypes()] //判断URL是否指向图片
  
  // 判断是否接收拖拽的文件 图片
  func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
    var canAccept = false
    
    let pasteBoard = draggingInfo.draggingPasteboard()
    
    if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
      canAccept = true
    }else if let types = pasteBoard.types, nonURLTypes.intersection(types).count > 0 {
      //nonURLTypes 集合是否包含了从粘贴板接受到的类型,如果是的话，接受拖拽的操作
      canAccept = true
    }
    
    return canAccept
  }
  
  //触发view的重绘
  var isReceivingDrag = false {
    didSet {
      needsDisplay = true
    }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    if isReceivingDrag {
      NSColor.selectedControlColor.set()
      
      let path = NSBezierPath(rect: bounds)
      path.lineWidth = Appearance.lineWidth
      path.stroke()
    }
  }
  
  // MARK: - NSDraggingDestination
  override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    let allow = shouldAllowDrag(sender)
    isReceivingDrag = allow
    return allow ? .copy : NSDragOperation()
  }
  
  override func draggingExited(_ sender: NSDraggingInfo?) {
    isReceivingDrag = false
  }
  
  //接受拖拽，处理数据，这里是最后一次接受或拒绝拖拽的机会
  override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let allow = shouldAllowDrag(sender)
    return allow
  }
  
  override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    isReceivingDrag = false
    let pasteBoard = sender.draggingPasteboard()
    let point = convert(sender.draggingLocation(), from: nil)
    
    if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL], urls.count > 0 {
      delegate?.processImageURLs(urls, center: point)
      return true
      
    }else if let image = NSImage(pasteboard: pasteBoard) {
      delegate?.processImage(image, center: point)
      return true
      
    }else if let types = pasteBoard.types, types.contains(SparkleDrag.type), let action = pasteBoard.string(forType: SparkleDrag.type) {
      delegate?.processAction(action, center: point)
      return true
    }
    
    return false
  }
  
  //we override hitTest so that this view which sits at the top of the view hierachy
  //appears transparent to mouse clicks
  override func hitTest(_ aPoint: NSPoint) -> NSView? {
    return nil
  }
}
