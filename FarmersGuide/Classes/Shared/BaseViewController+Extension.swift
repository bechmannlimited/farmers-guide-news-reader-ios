//
//  BaseViewController+Extension.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 03/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

extension BaseViewController {
    
    func setNavigationBarDefault() {
        
        let nvc = navigationController?.navigationController == nil ? navigationController : navigationController?.navigationController
        
        nvc?.navigationBar.tintColor = UINavigationBar.appearance().tintColor
        nvc?.navigationBar.animateNewImageChange(UINavigationBar.appearance().backgroundImageForBarMetrics(UIBarMetrics.Default)!)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
    }
    
    func setNavigationBarTransparent() {
        
        let nvc = navigationController?.navigationController == nil ? navigationController : navigationController?.navigationController
        
        nvc?.navigationBar.tintColor = UIColor.whiteColor()
        nvc?.navigationBar.animateNewImageChange(UIImage.imageWithColor(UIColor.clearColor(), size: CGSize(width: 10, height: 10)))
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
    }
}