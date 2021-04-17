import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  @objc dynamic var saveGame: SaveGame! = SaveGame()
  @IBOutlet var splash: NSWindow!
  @IBOutlet var select: NSWindow!
  @IBOutlet var cheat: NSWindow!

  var selectedSaveGame: Int = 1

  override init() {
    registerCustomValueTransformers()
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    splash.makeKeyAndOrderFront(self)
    splash.becomeKey()
  }

  @IBAction func pickSaveGame(_ sender: NSView) {
    selectedSaveGame = sender.tag
  }

  @IBAction func changeArea(_ sender: NSView) {
    saveGame.area = sender.tag
  }

  @IBAction func changeDifficulty(_ sender: NSView) {
    saveGame.difficulty = sender.tag
  }

  @IBAction func okeyDoeky(_ sender: Any) {
    splash.close()
    select.makeKeyAndOrderFront(self)
    select.becomeKey()
  }

  @IBAction func ok(_ sender: Any) {
    select.close()

    var readingError: Error? = nil
    do {
      self.saveGame = try readSaveGame(slot: selectedSaveGame)
    } catch {
      readingError = error
    }

    cheat.makeKeyAndOrderFront(self)
    cheat.becomeKey()

    if let error = readingError {
      cheat.presentError(error, modalFor: cheat, delegate: nil, didPresent: nil, contextInfo: nil)
    }
  }

  private func readSaveGame(slot: Int) throws -> SaveGame {
    let url = saveGameURL(slot: selectedSaveGame)
    let saveGame = SaveGame()
    if (try? url.checkResourceIsReachable()) ?? false {
      let stream = InputStream(url: url)!
      stream.open()
      defer { stream.close() }

      try stream.read(saveGame)
    }

    return saveGame
  }

  private func writeSaveGame(slot: Int) throws {
    let target = saveGameURL(slot: selectedSaveGame)
    let temp = target.appendingPathExtension("tmp")

    defer { try? FileManager.default.removeItem(at: temp) }

    let stream = OutputStream(url: temp, append: false)!
    stream.open()
    defer { stream.close() }

    try stream.write(saveGame)

    if (try? target.checkResourceIsReachable()) ?? false {
      try? FileManager.default.removeItem(at: target)
    }

    try FileManager.default.moveItem(at: temp, to: target)
  }

  private func saveGameURL(slot: Int) -> URL {
    let file = "./Preferences/MightyMike/PowerPeteSavedGameData\(slot)"
    return URL(
      fileURLWithPath: file, isDirectory: false,
      relativeTo: FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first)
  }

  @IBAction func maxAll(_ sender: Any) {
    self.saveGame.maxAll()
  }

  @IBAction func makeItSo(_ sender: Any) {
    self.cheat.endEditing(for: self.cheat.firstResponder)

    do {
      try self.writeSaveGame(slot: selectedSaveGame)
      NSApp.terminate(self)
    } catch {
      cheat.presentError(error, modalFor: cheat, delegate: nil, didPresent: nil, contextInfo: nil)
    }
  }

  @IBAction func cancel(_ sender: Any) {
    NSApp.terminate(self)
  }
}
