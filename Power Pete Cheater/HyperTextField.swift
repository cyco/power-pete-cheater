// This class was written in a joint effort by the fine folks over at StackOverflow
// https://stackoverflow.com/q/38340282

import Cocoa

@IBDesignable
class HyperlinkTextField: NSTextField {

  @IBInspectable var href: String = ""

  override func resetCursorRects() {
    discardCursorRects()
    addCursorRect(self.bounds, cursor: NSCursor.pointingHand)
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    let attributes: [NSAttributedString.Key: Any] = [
      NSAttributedString.Key.foregroundColor: NSColor.linkColor,
      NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single,
    ]
    attributedStringValue = NSAttributedString(string: self.stringValue, attributes: attributes)
  }

  override func mouseDown(with theEvent: NSEvent) {
    if let localHref = URL(string: href) {
      NSWorkspace.shared.open(localHref)
    }
  }
}
