//
//  Session+FarmersGuide.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kMainAppFont = "AppleSDGothicNeo"

//enum AppFont: String {
//    
//    case AppleSDGothNeoThin = "AppleSDGothicNeo-Thin"
//    case AppleSDGothNeoRegular = "AppleSDGothicNeo-Regular"
//    case AppleSDGothNeoBold = "AppleSDGothicNeo-Bold"
//}

enum FontWeight : String {
    
    case Thin = "Thin"
    case Regular = "Regular"
    case Bold = "Bold"
}

extension Session {
    
    class func AppFont(size: CGFloat, weight: FontWeight) -> UIFont {
        
        return UIFont(name: "\(kMainAppFont)-\(weight.rawValue)", size: size)!
    }
}