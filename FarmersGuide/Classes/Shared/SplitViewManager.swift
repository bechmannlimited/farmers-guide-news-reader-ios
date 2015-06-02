//
//  SplitViewManager.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

private var kSplitViewManagerSharedInstance = SplitViewManager()

public class SplitViewManager: NSObject {
   
    public var splitViewController: UISplitViewController = UISplitViewController() {
        
        didSet {
            
            splitViewController.delegate = self
        }
    }

    public class func sharedManager() -> SplitViewManager {
        
        return kSplitViewManagerSharedInstance
    }
}

extension SplitViewManager: UISplitViewControllerDelegate {
    
    public func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            
            if let topAsDetailController = secondaryAsNavController.topViewController as? ArticleViewController {
                
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }
}

extension UISplitViewController {
    
    public var detailViewController: UIViewController {
        
        get {
            
            return viewControllers[viewControllers.count-1] as! UIViewController
        }
        
        set {
            
            viewControllers[viewControllers.count-1] = newValue
        }
    }
}
