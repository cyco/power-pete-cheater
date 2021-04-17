import Foundation

extension NSValueTransformerName {
  static let isZeroTransformerName = NSValueTransformerName(rawValue: "IsZero")
  static let isOneTransformerName = NSValueTransformerName(rawValue: "IsOne")
  static let isTwoTransformerName = NSValueTransformerName(rawValue: "IsTwo")
  static let isThreeTransformerName = NSValueTransformerName(rawValue: "IsThree")
  static let isFourTransformerName = NSValueTransformerName(rawValue: "IsFour")

  static let addOneTransformerName = NSValueTransformerName(rawValue: "AddOne")
}

func registerCustomValueTransformers() {
  ValueTransformer.setValueTransformer(
    IsConstantIntValueTransformer(target: 0), forName: .isZeroTransformerName)
  ValueTransformer.setValueTransformer(
    IsConstantIntValueTransformer(target: 1), forName: .isOneTransformerName)
  ValueTransformer.setValueTransformer(
    IsConstantIntValueTransformer(target: 2), forName: .isTwoTransformerName)
  ValueTransformer.setValueTransformer(
    IsConstantIntValueTransformer(target: 3), forName: .isThreeTransformerName)
  ValueTransformer.setValueTransformer(
    IsConstantIntValueTransformer(target: 4), forName: .isFourTransformerName)

  ValueTransformer.setValueTransformer(
    OffsetNumberFormatter(offset: 1), forName: .addOneTransformerName)
}
