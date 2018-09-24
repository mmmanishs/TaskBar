//
//  HiddenFileManager.swift
//  TaskBar
//
//  Created by Singh,Manish on 5/20/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//


import Foundation
class HiddenFileManager: NSObject {
    let shell = Shell()
    
    static let sharedInstance  = HiddenFileManager()
    
    override init(){
        super.init()
        self.fetchHiddenFileState()
    }
    
    func getMenuItems() -> [MSMenuItem]? {
        let menuItem = MSMenuItem(title: HiddenFileManager.sharedInstance.fetchHiddenFileState() , action: #selector(AppDelegate.hiddenFilesToggleState), keyEquivalent: "")
        menuItem.catagory = "Hidden Files"
        
        return [menuItem]
    }
    func hiddenFilesToggleState() {
        HiddenFileManager.sharedInstance.toggleState()
        (statusItem.menu as! MSMenu).changeMenuItemNameForCatagory("Hidden Files", name: HiddenFileManager.sharedInstance.fetchHiddenFileState())
    }


    func fetchHiddenFileState() -> String{
        let hiddenState = shell.exe("defaults read com.apple.Finder AppleShowAllFiles")
        print(hiddenState)
        if hiddenState == "NO\n" {
            return "Show hidden files"
        }
        else {
            return "Hide hidden files"
        }
    }
    func showHiddenFiles(_ showHiddenFiles:Bool) {
        if showHiddenFiles{
            shell.exe("defaults write com.apple.Finder AppleShowAllFiles YES")
        }
        else{
            shell.exe("defaults write com.apple.Finder AppleShowAllFiles NO")
        }
    }
    func toggleState() {
        let hiddenState = shell.exe("defaults read com.apple.Finder AppleShowAllFiles")
        if hiddenState == "NO\n" {
            self.showHiddenFiles(true)
        }
        else {
            self.showHiddenFiles(false)
        }
        shell.execute("killall" , "Finder")
        shell.execute("open", "~")
    }
}
