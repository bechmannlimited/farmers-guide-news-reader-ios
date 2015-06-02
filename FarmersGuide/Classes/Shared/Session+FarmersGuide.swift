//
//  Session+FarmersGuide.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

enum FontWithWeight: String {
    
    case Thin = "AppleSDGothicNeo-Thin"
    case Regular = "AppleSDGothicNeo-Regular"
}

extension Session {
    
    class func AppFont(size: CGFloat, weight: FontWithWeight) -> UIFont {
        
        return UIFont(name: weight.rawValue, size: size)!
    }
}