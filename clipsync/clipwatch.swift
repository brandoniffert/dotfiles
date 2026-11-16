// Records when the Mac clipboard last changed, for clipsync. Never reads clipboard content.
// Build: swiftc -O clipwatch.swift -o ~/.local/bin/clipwatch
import AppKit

let dir = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Library/Application Support/clipsync")
try? FileManager.default.createDirectory(
    at: dir, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
let file = dir.appendingPathComponent("changed")

let pasteboard = NSPasteboard.general
var last = pasteboard.changeCount
while true {
    Thread.sleep(forTimeInterval: 0.25)
    let count = pasteboard.changeCount
    if count != last {
        last = count
        try? String(Date().timeIntervalSince1970).write(to: file, atomically: true, encoding: .utf8)
    }
}
