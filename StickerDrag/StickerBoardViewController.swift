//
//  StickerBoardViewController
//  Created by YangWei on 2018/7/2.
//  Copyright © 2018年 Apple-YangWei. All rights reserved.
//

import Cocoa


class StickerBoardViewController: NSViewController {
  
  @IBOutlet var topLayer: DestinationView!
  @IBOutlet var targetLayer: NSView!
  @IBOutlet var invitationLabel: NSTextField!
  
  enum Appearance {
    static let maxStickerDimension: CGFloat = 150.0
    static let shadowOpacity: Float =  0.4
    static let shadowOffset: CGFloat = 4
    static let imageCompressionFactor = 1.0
    static let maxRotation: UInt32 = 12
    static let rotationOffset: CGFloat = 6
    static let randomNoise: UInt32 = 200
    static let numStars = 20
    static let maxStarSize: CGFloat = 30
    static let randonStarSizeChange: UInt32 = 25
    static let randomNoiseStar: UInt32 = 100
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    topLayer.delegate = self
    configureShadow(targetLayer)
  }
  
  func configureShadow(_ view: NSView) {
    if let layer = view.layer {
      layer.shadowColor = NSColor.black.cgColor
      layer.shadowOpacity = Appearance.shadowOpacity
      layer.shadowOffset = CGSize(width: Appearance.shadowOffset, height: -Appearance.shadowOffset)
      layer.masksToBounds = false
    }
  }
  
  
  @IBAction func saveAction(_ sender: AnyObject) {
    if let tiffdata = targetLayer.snapshot().tiffRepresentation,
      let bitmaprep = NSBitmapImageRep(data: tiffdata) {
      
      let props = [NSImageCompressionFactor: Appearance.imageCompressionFactor]
      if let bitmapData = NSBitmapImageRep.representationOfImageReps(in: [bitmaprep], using: .JPEG, properties: props) {
        
        let path: NSString = "~/Desktop/StickerDrag.jpg"
        let resolvedPath = path.expandingTildeInPath
        
        try! bitmapData.write(to: URL(fileURLWithPath: resolvedPath), options: []) 
      }
    }
  }
}

// MARK: - DestinationViewDelegate
extension StickerBoardViewController: DestinationViewDelegate {
  
  func processImageURLs(_ urls: [URL], center: NSPoint) {
    for (index, url) in urls.enumerated() {
      if let image = NSImage(contentsOf: url) {
        var newCenter = center
        
        if index > 0 {
          newCenter = center.addRandomNoise(Appearance.randomNoise)
        }
        
        processImage(image, center: newCenter)
      }
    }
  }
  
  func processImage(_ image: NSImage, center: NSPoint) {
    invitationLabel.isHidden = true
    
    let constrainedSize = image.aspectFitSizeForMaxDimension(Appearance.maxStickerDimension)
    let subview = NSImageView(frame: NSRect(x: center.x - constrainedSize.width/2, y: center.y - constrainedSize.height/2, width: constrainedSize.width, height: constrainedSize.height))
    
    subview.image = image
    targetLayer.addSubview(subview)
    
    let maxrotation = CGFloat(arc4random_uniform(Appearance.maxRotation)) - Appearance.rotationOffset
    subview.frameCenterRotation = maxrotation
  }
  
  func processAction(_ action: String, center: NSPoint) {
    if action == SparkleDrag.action {
      invitationLabel.isHidden = true
      
      if let image = NSImage(named:"star") {
        for _ in 1..<Appearance.numStars {
          
          let maxSize:CGFloat = Appearance.maxStarSize
          let sizeChange = CGFloat(arc4random_uniform(Appearance.randonStarSizeChange))
          let finalSize = maxSize - sizeChange
          let newCenter = center.addRandomNoise(Appearance.randomNoiseStar) //生成一些随机的数字来改变位置
          
          let imageFrame = NSRect(x: newCenter.x, y: newCenter.y, width: finalSize , height: finalSize)
          let imageView = NSImageView(frame:imageFrame)
          
          let newImage = image.tintedImageWithColor(NSColor.randomColor())
          
          imageView.image = newImage
          targetLayer.addSubview(imageView)
        }
      }
    }
  }
}

