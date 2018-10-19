//
//  Stylesheet.swift
//  Venew
//
//  Created by Masai Young on 8/9/18.
//  Copyright © 2018 Masai Young. All rights reserved.
//

import UIKit

enum Stylesheet {
    
    enum Colors {
        static let MainGreen = UIColor(hex: "86CB92")
        static let DarkGreen = UIColor(hex: "5D9474")
        static let LightGray = UIColor(hex: "D1DECF")
        static let Navy = UIColor(hex: "404E7C")
        // Colors borrowed from Tweetbot's dark color scheme
    }
    
    enum Fonts {
        static let Regular = "Avenir-Light"
        static let Bold = "Avenir-Medium"
    }
    
    enum Contexts {
        enum Global {
            static let StatusBarStyle = UIStatusBarStyle.lightContent
            static let BackgroundColor = Colors.MainGreen
        }
        
        enum NavigationController {
            
        }
        
    }
    
}
