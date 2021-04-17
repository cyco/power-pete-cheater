import Foundation

class OffsetNumberFormatter: ValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return NSNumber.self
  }

  override class func allowsReverseTransformation() -> Bool {
    return true
  }

  private var offset: Int
  private var formatter: NumberFormatter

  init(offset: Int) {
    self.offset = offset
    self.formatter = NumberFormatter()
  }

  override func transformedValue(_ value: Any?) -> Any? {
    if let value = value as? NSNumber {
      return NSNumber(value: value.intValue + 1)
    }

    return value
  }

  override func reverseTransformedValue(_ value: Any?) -> Any? {
    if let value = value as? NSNumber {
      return NSNumber(value: value.intValue - 1)
    }

    return value
  }
}
