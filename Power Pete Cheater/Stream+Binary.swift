import Foundation

extension InputStream {
  func readString(maxLength: Int) -> String {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
    defer { buffer.deallocate() }
    guard self.read(buffer, maxLength: maxLength) <= maxLength else {
      fatalError()
    }

    return String(cString: buffer)
  }

  func readInt8() throws -> Int8 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 1) == 1 else { throw self.streamError ?? POSIXError(.EIO) }
    return UnsafeRawPointer(buffer).load(as: Int8.self)
  }

  func readUInt8() throws -> UInt8 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 1) == 1 else { throw self.streamError ?? POSIXError(.EIO) }
    return UnsafeRawPointer(buffer).load(as: UInt8.self)
  }

  func readInt16() throws -> Int16 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 2)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 2) == 2 else { throw self.streamError ?? POSIXError(.EIO) }
    return UnsafeRawPointer(buffer).load(as: Int16.self)
  }

  func readUInt16() throws -> UInt16 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 2)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 2) == 2 else { throw self.streamError ?? POSIXError(.EIO) }
    return UnsafeRawPointer(buffer).load(as: UInt16.self)
  }

  func readInt32() throws -> Int32 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 4) == 4 else { throw self.streamError ?? POSIXError(.EIO) }

    return UnsafeRawPointer(buffer).load(as: Int32.self)
  }

  func readUInt32() throws -> UInt32 {
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
    defer { buffer.deallocate() }

    guard self.read(buffer, maxLength: 4) == 4 else { throw self.streamError ?? POSIXError(.EIO) }
    return UnsafeRawPointer(buffer).load(as: UInt32.self)
  }

}

extension OutputStream {
  func write<DataType: DataProtocol>(_ data: DataType) throws -> Int {
    var buffer = Array(data)
    guard buffer.count > 0 else { return 0 }
    let result = self.write(&buffer, maxLength: buffer.count)
    guard result >= 0 else { throw self.streamError ?? POSIXError(.EIO) }
    return result
  }

  func write(_ data: UInt8) throws -> Int {
    var buffer = Array(arrayLiteral: data)
    let result = self.write(&buffer, maxLength: buffer.count)
    if result < 0 {
      throw self.streamError ?? POSIXError(.EIO)
    } else {
      return result
    }
  }

  func write(_ data: Int8) throws -> Int {
    return try write(UInt8(bitPattern: data))
  }

  func write(_ data: UInt16) throws -> Int {
    let values: [UInt8] = [
      UInt8(truncatingIfNeeded: data & 0xFF), UInt8(truncatingIfNeeded: data >> 8),
    ]

    return try write(values)
  }

  func write(_ data: Int16) throws -> Int {
    return try write(UInt16(bitPattern: data))
  }

  func write(_ data: Int32) throws -> Int {
    return try write(UInt32(bitPattern: data))
  }

  func write(_ data: UInt32) throws -> Int {
    let values: [UInt8] = [
      UInt8(truncatingIfNeeded: data >> 0),
      UInt8(truncatingIfNeeded: data >> 8),
      UInt8(truncatingIfNeeded: data >> 16),
      UInt8(truncatingIfNeeded: data >> 24),
    ]

    return try write(values)
  }
}
