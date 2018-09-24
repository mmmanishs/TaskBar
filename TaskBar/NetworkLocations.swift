//
//  NetworkLocations.swift
//  MacUtilities
//
//  Created by Singh,Manish on 5/11/16.
//  Copyright © 2016 Singh,Manish. All rights reserved.
//

import Foundation
import Cocoa

class NetworkLocations {
    var locations:[String] = []
    var currentLocation:String = ""
    let shell = Shell()

    static let sharedInstance  = NetworkLocations()
    
    init(){
        self.fetchNetworkLocations()
    }
    
    func getMenuItems() -> [MSMenuItem]? {
        
        var menuItems = [MSMenuItem]()
        for (index,location) in NetworkLocations.sharedInstance.locations.enumerated() {
            
            let menuItem = MSMenuItem(title: location , action: #selector(AppDelegate.selectNetworkLocation(_:)), keyEquivalent: "")
            menuItem.catagory = "Network"
            menuItem.tag = index
            menuItems.append(menuItem)
            if location == NetworkLocations.sharedInstance.currentLocation {
                menuItem.state = NSOnState
            }
        }
        
        return menuItems
    }
    
    func refreshLocations() {
        self.fetchNetworkLocations()
    }
    fileprivate func fetchNetworkLocations(){
        let netStatOutput = shell.exe("scselect")?.components(separatedBy: "\n ")
        print(netStatOutput)
        var scannedString: NSString?
        locations.removeAll()
        for net:String in netStatOutput! {
            let scanner:Scanner = Scanner(string: net)
            if scanner.scanUpTo("(", into: nil){
                if scanner.scanString("(", into: nil){
                    scanner.scanUpTo(")", into:&scannedString)
                    locations.append(scannedString as! String)
                    if net[0] == "*" {
                        currentLocation = scannedString as! String
                    }
                    scannedString = ""
                }
            }
            
        }
        locations.removeFirst()
    }
    
    func setNetworkLocation(_ location:String){
        shell.execute("scselect",location)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end = <#T##String.CharacterView corresponding to `start`##String.CharacterView#>.index(start, offsetBy: r.upperBound - r.lowerBound)
        return self[Range(start ..< end)]
    }
}
