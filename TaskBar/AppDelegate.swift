//
//  AppDelegate.swift
//  TaskBar
//
//  Created by Singh,Manish on 5/18/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Cocoa

let statusItem = NSStatusBar.system().statusItem(withLength: -2)

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    
    let shell = Shell()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
        }
        statusItem.menu = self.getMenu()
    }
    
    func selectNetworkLocation(_ sender:AnyObject){
        
        let menuItem = sender as? MSMenuItem
        NetworkLocations.sharedInstance.setNetworkLocation((NetworkLocations.sharedInstance.locations[(menuItem?.tag)!]))
        
        let menu:MSMenu = statusItem.menu as! MSMenu
        menu.selectMenuItem(menuItem)
        
    }
    func cleanUpScreenShots() {
        let clean = CleanupScreenShots()
        clean.cleanUp()
    }
    
    func hiddenFilesToggleState() {
        HiddenFileManager.sharedInstance.toggleState()
        (statusItem.menu as! MSMenu).changeMenuItemNameForCatagory("Hidden Files", name: HiddenFileManager.sharedInstance.fetchHiddenFileState())
    }
    
    func getMenu() -> MSMenu {
        let menu = MSMenu()
        
        if let menuItems = NetworkLocations.sharedInstance.getMenuItems() {
            menuItems.forEach({menuItem in
                menu.addItem(menuItem)
            })
        }
        menu.addItem(MSMenuItem.separator())
        //Hidden file manager
        if let menuItems = HiddenFileManager.sharedInstance.getMenuItems() {
            menuItems.forEach({menuItem in
                menu.addItem(menuItem)
            })
        }
        
        menu.addItem(MSMenuItem.separator())
        
        
        menu.addItem(MSMenuItem(title: "Disconnect Simulator" , action: #selector(AppDelegate.disconnectSimulator), keyEquivalent: ""))

        menu.addItem(MSMenuItem.separator())
        
        
        menu.addItem(MSMenuItem(title: "Cleanup images" , action: #selector(AppDelegate.cleanUpScreenShots), keyEquivalent: ""))
        
        menu.addItem(MSMenuItem.separator())
        

        
        if let menuItems = LaunchAtLogin.sharedInstance.getMenuItems() {
            menuItems.forEach({menuItem in
                menu.addItem(menuItem)
            })
        }
        menu.addItem(MSMenuItem.separator())
        
        
        menu.addItem(MSMenuItem(title: "Quit" , action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        
        
        return menu
    }
    
    func launchAtStartup(_ sender:AnyObject) {
        LaunchAtLogin.sharedInstance.toggleLaunchAtStartup()
        (statusItem.menu as! MSMenu).changeMenuItemNameForCatagory("Launch", name: LaunchAtLogin.sharedInstance.getLauchItemStateTitle())
        
        let menuItem = sender as? MSMenuItem
        
        let menu:MSMenu = statusItem.menu as! MSMenu
        if LaunchAtLogin.sharedInstance.applicationIsInStartUpItems() {
            menu.selectMenuItem(menuItem)
        }
        else {
            menu.deSelectMenuItem(menuItem)
        }
    }
    
    func disconnectSimulator() {
        let shell = Shell()
        shell.exe("killall SpringBoard")
    }
    func quit() {
        NSApplication.shared().terminate(nil)
    }
}

