import Foundation

@objc
class SaveGame: NSObject {
  static let maxMagicLength = 32
  static let magic = "Mighty Mike Save v0"
  static let weaponCount = 50
  static let weaponsKeyPathPattern = #"^?(<=weapons\.@)?[0-9]+$"#
  @objc dynamic var magic: String = SaveGame.magic
  @objc dynamic var score: Int = 0
  @objc dynamic var coins: Int = 0
  @objc dynamic var lives: Int = 2
  @objc dynamic var hearts: Int = 5
  @objc dynamic var maxHearts: Int = 5
  @objc dynamic var difficulty: Int = 0
  @objc dynamic var weapons = Array(repeating: 0, count: weaponCount)
  @objc dynamic var currentWeapon: Int = 0
  @objc dynamic var currentWeaponIndex: Int = 0
  @objc dynamic var ownedWeapons: Int = 1
  @objc dynamic var area: Int = 0
  @objc dynamic var level: Int = 0

  override init() {
    weapons[0] = 500
  }

  func maxAll() {
    for i in 0...14 {
      weapons[i] = 500
    }

    lives = 99
    maxHearts = 99
    hearts = 99

    score = 9_999_999
  }

  override func value(forKeyPath keyPath: String) -> Any? {
    if let range = keyPath.range(of: Self.weaponsKeyPathPattern, options: .regularExpression) {
      let key = keyPath[range] as NSString

      return self.weapons[key.integerValue]
    }

    return super.value(forKeyPath: keyPath)
  }

  override func setValue(_ value: Any?, forKeyPath keyPath: String) {
    if let range = keyPath.range(of: Self.weaponsKeyPathPattern, options: .regularExpression) {
      let key = keyPath[range] as NSString

      self.weapons[key.integerValue] = value as! Int
      return
    }

    super.setValue(value, forKeyPath: keyPath)

  }
}
