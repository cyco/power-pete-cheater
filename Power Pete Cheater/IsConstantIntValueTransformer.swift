import Foundation

class IsConstantIntValueTransformer: ValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return NSNumber.self
  }

  override class func allowsReverseTransformation() -> Bool {
    return true
  }

  private var target: Int

  init(target: Int) {
    self.target = target
  }

  override func transformedValue(_ value: Any?) -> Any? {
    if let value = value as? NSNumber {
      return NSNumber(booleanLiteral: value.intValue == self.target)
    }

    return NSNumber(booleanLiteral: false)
  }
  override func reverseTransformedValue(_ value: Any?) -> Any? {
    if let value = value as? NSNumber {
      return value.boolValue ? self.target : nil
    }

    return value
  }
}
