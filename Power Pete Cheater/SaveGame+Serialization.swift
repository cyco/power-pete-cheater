import Foundation

enum SaveGameReadingError: Error {
  case invalidFileMagic
  case invalidFileFormat
}

extension InputStream {
  func read(_ game: SaveGame) throws {
    game.magic = self.readString(maxLength: SaveGame.maxMagicLength)
    guard game.magic == SaveGame.magic else { throw SaveGameReadingError.invalidFileMagic }

    game.weapons = Array(repeating: 0, count: SaveGame.weaponCount)
    for _ in 0...(SaveGame.weaponCount - 1) {
      let type = Int(try self.readUInt8())
      _ = try self.readUInt8()  // struct padding
      let ammo = Int(try self.readUInt16())
      guard type <= game.weapons.capacity else { throw SaveGameReadingError.invalidFileFormat }

      if game.weapons[type] == 0 {
        game.weapons[type] = ammo
      }
    }

    game.score = Int(try self.readInt32())
    game.coins = Int(try self.readInt32())
    game.lives = Int(try self.readInt16())
    game.currentWeapon = Int(try self.readUInt8())
    game.area = Int(try self.readUInt8())
    game.level = Int(try self.readUInt8())
    game.ownedWeapons = Int(try self.readUInt8())
    game.currentWeaponIndex = Int(try self.readUInt8())
    _ = try self.readUInt8()  // struct padding
    game.hearts = Int(try self.readInt16())
    game.maxHearts = Int(try self.readInt16())
    game.difficulty = Int(try self.readInt8())
  }
}

extension OutputStream {
  func write(_ game: SaveGame) throws {
    _ = try self.write(game.magic.data(using: .ascii)!)
    _ = try self.write(UInt8(0))
    for _ in 0...(SaveGame.maxMagicLength - game.magic.count - 2) {
      _ = try self.write(UInt8(0xff))
    }

    var ownedWeapons = 0
    var currentWeaponIndex = 0
    for i in 0..<SaveGame.weaponCount {
      let ammo = i < game.weapons.count ? game.weapons[i] : 0
      if ammo > 0 || i == game.currentWeapon {
        _ = try self.write(UInt8(i))
        _ = try self.write(UInt8(0))  // struct padding
        _ = try self.write(UInt16(ammo))

        ownedWeapons = ownedWeapons + 1
      }

      if i == game.currentWeapon {
        currentWeaponIndex = i
      }
    }

    for _ in ownedWeapons..<SaveGame.weaponCount {
      _ = try self.write(UInt32(0))
    }

    _ = try self.write(Int32(game.score))
    _ = try self.write(Int32(game.coins))
    _ = try self.write(Int16(game.lives))
    _ = try self.write(UInt8(game.currentWeapon))
    _ = try self.write(UInt8(game.area))
    _ = try self.write(UInt8(game.level))
    _ = try self.write(UInt8(ownedWeapons))
    _ = try self.write(UInt8(currentWeaponIndex))
    _ = try self.write(UInt8(0xFF))  // struct padding
    _ = try self.write(Int16(game.hearts))
    _ = try self.write(Int16(game.maxHearts))
    _ = try self.write(Int8(game.difficulty))

    _ = try self.write(UInt8(0xFF))  // struct padding
    _ = try self.write(UInt8(0xFF))  // struct padding
    _ = try self.write(UInt8(0xFF))  // struct padding
  }
}
