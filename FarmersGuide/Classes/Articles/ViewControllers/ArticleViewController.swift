//
//  ArticleViewController.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var detailItem: AnyObject?
    var article = Article()
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        textView.text = article.Subtitle
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FastForward, target: self, action: "")
    }

    func setupTextView() {
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(textView)
        textView.fillSuperView(UIEdgeInsetsZero)
    }
}
