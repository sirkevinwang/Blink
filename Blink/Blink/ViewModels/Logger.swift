//
//  Logger.swift
//  Blink
//
//  Created by Kevin Wang on 1/2/22.
//
import Foundation

class Logger {
    let logFile: URL?
    
    init() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH-mm-ss"
        let dateString = formatter.string(from: Date())
        let fileName = "blink_logs_\(dateString).csv"
        self.logFile = documentsDirectory.appendingPathComponent(fileName)
    }

    func log(_ message: String) {
        guard let logFile = logFile else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let timestamp = formatter.string(from: Date())
        guard let data = (timestamp + "," + message + "\n").data(using: String.Encoding.utf8) else { return }

        if FileManager.default.fileExists(atPath: logFile.path) {
            if let fileHandle = try? FileHandle(forWritingTo: logFile) {
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            }
        } else {
            try? data.write(to: logFile, options: .atomicWrite)
        }
    }
}
