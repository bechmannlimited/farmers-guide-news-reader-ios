//
//  UINavigationBar+Extension.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 03/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

public extension UINavigationBar {
    
    public func animateNewImageChange(image:UIImage) {
        
        animateNewImageChange(image, duration: 0.5)
    }
    
    public func animateNewImageChange(image:UIImage, duration: CFTimeInterval) {
        
        var transition = CATransition()
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionFade
        transition.duration = duration
        
        layer.addAnimation(transition, forKey: nil)
        setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
    }
}