import Cocoa

extension NSView {
  /**
   Take a snapshot of a current state NSView and return an NSImage
   
   - returns: NSImage representation
   */
  func snapshot() -> NSImage {
    let pdfData = dataWithPDF(inside: bounds)
    let image = NSImage(data: pdfData)
    return image ?? NSImage()
  }
}

extension NSPoint {
  /**
   Mutate an NSPoint with a random amount of noise bounded by maximumDelta
   
   - parameter maximumDelta: change range +/-
   
   - returns: mutated point
   */
  func addRandomNoise(_ maximumDelta: UInt32) -> NSPoint {
    
    var newCenter = self
    let range = 2 * maximumDelta
    let xdelta = arc4random_uniform(range)
    let ydelta = arc4random_uniform(range)
    newCenter.x += (CGFloat(xdelta) - CGFloat(maximumDelta))
    newCenter.y += (CGFloat(ydelta) - CGFloat(maximumDelta))
    
    return newCenter
  }
}


extension NSImage {
  
  /**
   Tint image with supplied color
   
   - parameter color: color to use as tint
   
   - returns: tinted image
   */
  func tintedImageWithColor(_ color: NSColor) -> NSImage {
    let newImage = NSImage(size: size)
    newImage.lockFocus()
    color.drawSwatch(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
    draw(at: NSZeroPoint, from: NSZeroRect, operation: .destinationIn, fraction: 1.0)
    newImage.unlockFocus()
    return newImage
  }
  
  /**
   Derives new size for an image constrained to a maximum dimension while keeping AR constant
   
   - parameter maxDimension: maximum horizontal or vertical dimension for new size
   
   - returns: new size
   */
  func aspectFitSizeForMaxDimension(_ maxDimension: CGFloat) -> NSSize {
    var width =  size.width
    var height = size.height
    if size.width > maxDimension || size.height > maxDimension {
      let aspectRatio = size.width/size.height
      width = aspectRatio > 0 ? maxDimension : maxDimension*aspectRatio
      height = aspectRatio < 0 ? maxDimension : maxDimension/aspectRatio
    }
    return NSSize(width: width, height: height)
  }
}

extension NSColor {
  /**
   A random color from list
   
   - returns: color
   */
  class func randomColor() -> NSColor {
    let colors:[NSColor] = [NSColor.red, NSColor.green, NSColor.blue, NSColor.orange, NSColor.cyan, NSColor.magenta, NSColor.yellow]
    return colors[Int(arc4random_uniform(UInt32(colors.count)))]
  }
}

