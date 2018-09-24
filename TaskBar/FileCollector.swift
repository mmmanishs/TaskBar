//
//  FileFunctions.swift
//  Diagnose
//
//  Created by Singh,Manish on 6/10/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
func getContentOfFile(_ file:AnyObject) -> String?  {
    
    let filePath = file as! String
    let content = try? Data.init(contentsOf: URL(fileURLWithPath: filePath))
    let str = String(data:content!,encoding: String.Encoding.utf8)
    return str
}
func getFilesWithExtension(_ type:String, path:String?) -> [String] {
    
    guard let path = path else{
        return []
    }
    guard let enumerator:FileManager.DirectoryEnumerator = FileManager.default.enumerator(atPath: path) else {
        return []
    }
    let filteredFilePaths = NSMutableArray()
    for filePath in enumerator {
        if (filePath as AnyObject).pathExtension == type{
            filteredFilePaths.add(filePath)
        }
    }
    return filteredFilePaths
}
