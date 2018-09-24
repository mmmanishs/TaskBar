
//
//  shell.swift
//  FileMan
//
//  Created by Singh,Manish on 4/8/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation

class Shell {
    func execute(_ args: String...) -> String? {
        let task = Process()
        let pipe:Pipe = Pipe()
        task.standardOutput = pipe
        
        task.launchPath = "/usr/bin/env"
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        
        return getDataStringFromPipe(pipe)
        
    }
    
    func exe(_ arguments:String) -> String? {
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path = path + "/shellScript.sh"
        do{
            print("Path of the command file : \(path)")
            try arguments.write(to: URL(fileURLWithPath: path), atomically: true, encoding: String.Encoding.utf8)
        }
        catch{
            print("Exceptioned happened")
        }
        
        return self.execute("sh",path)
    }
    
//    func runScript(script:String) -> String? {
//        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//        path = path + "/shellScript.sh"
//
//        do{
//            print("Path of the command file : \(path)")
//            try script.writeToURL(NSURL.fileURLWithPath(path), atomically: true, encoding: NSUTF8StringEncoding)
//        }
//        catch{
//            print("Exceptioned happened")
//        }
//        
//        return self.execute("sh",path)
//
//    }
    func getDataStringFromPipe(_ pipe:Pipe) -> String?{
        let fileHandle:FileHandle = pipe.fileHandleForReading
        let data = fileHandle.readDataToEndOfFile()
        
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        return dataString
        
    }
    
}
