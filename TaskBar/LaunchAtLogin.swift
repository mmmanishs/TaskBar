//
//  LaunchAtLogin.swift
//  TaskBar
//
//  Created by Singh,Manish on 7/11/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
import Cocoa

class LaunchAtLogin:NSObject {
    
    static let sharedInstance  = LaunchAtLogin()
    
    func getMenuItems() -> [MSMenuItem]? {
        
        let menuItemScreenshotCleaner = MSMenuItem(title: self.getLauchItemStateTitle() , action: #selector(AppDelegate.launchAtStartup(_:)), keyEquivalent: "")
        menuItemScreenshotCleaner.catagory = "Launch"
        
        if self.applicationIsInStartUpItems() {
            menuItemScreenshotCleaner.state = NSOnState
        }
        else {
            menuItemScreenshotCleaner.state = NSOffState
        }
        return [menuItemScreenshotCleaner]
    }
    
    
    func getLauchItemStateTitle() -> String {
        return "Launch at Startup"
    }
    
    func applicationIsInStartUpItems() -> Bool {
        return (itemReferencesInLoginItems().existingReference != nil)
    }
    
    func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        let itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.allocate(capacity: 1)
        if let appUrl : URL = URL(fileURLWithPath: Bundle.main.bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileList?
            if loginItemsRef != nil {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                print("There are \(loginItems.count) login items")
                let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
                for i in 0 ..< loginItems.count {
                    let currentItemRef: LSSharedFileListItem = loginItems.object(at: i) as! LSSharedFileListItem
                    if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                        if let urlRef: URL =  itemUrl.pointee?.takeRetainedValue() as URL? {
                            print("URL Ref: \(urlRef.lastPathComponent)")
                            if urlRef == appUrl {
                                return (currentItemRef, lastItemRef)
                            }
                        }
                    } else {
                        print("Unknown login application")
                    }
                }
                //The application was not found in the startup list
                return (nil, lastItemRef)
            }
        }
        return (nil, nil)
    }
    
    func toggleLaunchAtStartup() {
        let itemReferences = itemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileList?
        if loginItemsRef != nil {
            if shouldBeToggled {
                if let appUrl : CFURL = URL(fileURLWithPath: Bundle.main.bundlePath) as CFURL? {
                    LSSharedFileListInsertItemURL(
                        loginItemsRef,
                        itemReferences.lastReference,
                        nil,
                        nil,
                        appUrl,
                        nil,
                        nil
                    )
                    print("Application was added to login items")
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                    print("Application was removed from login items")
                }
            }
        }
    }

}

