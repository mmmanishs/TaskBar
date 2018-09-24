//
//  MSMenu.swift
//  TaskBar
//
//  Created by Singh,Manish on 5/19/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Cocoa

class MSMenu: NSMenu {

    func selectMenuItem(_ menuItem:NSMenuItem?) {
        
        guard let menuItem = menuItem else {
            return
        }
        for item in self.items {
            if item.tag == menuItem.tag {
                menuItem.state = NSOnState
            }
            else{
                item.state = NSOffState
            }
        }
    }
    
    func deSelectMenuItem(_ menuItem:NSMenuItem?) {
        
        guard let menuItem = menuItem else {
            return
        }
        menuItem.state = NSOffState
    }
    
    func changeMenuItemNameForCatagory(_ catagory:String, name:String) {
        for item in self.items {
            if let menuItem = item as? MSMenuItem{
                if menuItem.catagory ==  catagory{
                    menuItem.title = name
                }

            }
        }
    }
}
