//
//  CleanUpScreenShots.swift
//  TaskBar
//
//  Created by Singh,Manish on 6/14/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation


import Foundation
class CleanupScreenShots:NSObject {
    
    static let sharedInstance  = CleanupScreenShots()

    func getMenuItems() -> [MSMenuItem]? {
        
        let menuItemScreenshotCleaner = MSMenuItem(title: "Clean up screenshots" , action: #selector(AppDelegate.cleanUpScreenShots), keyEquivalent: "")
        menuItemScreenshotCleaner.catagory = "Screenshot"
        
        return [menuItemScreenshotCleaner]
    }
    
    func cleanUpScreenShots() {
        let clean = CleanupScreenShots()
        clean.cleanUp()
    }

    func cleanUp() {
        let imageFiles = getFilesWithExtension("png", path:"/Users/ldq847/Desktop")
        let fileManager = FileManager.default
        
        // Move 'hello.swift' to 'subfolder/hello.swift'
        
        for file in imageFiles {
        do {
            try fileManager.moveItem(atPath: file, toPath: "/Users/ldq847/Documents/Screenshots/hello.swift")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        }
        
    }
    
}

