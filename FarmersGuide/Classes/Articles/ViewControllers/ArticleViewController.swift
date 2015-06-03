//
//  ArticleViewController.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kHeaderViewHeight: CGFloat = 160
private let kHeaderViewMarginBottom: CGFloat = 10
private let kWebViewPadding: CGFloat = 5
private let kWebViewFontSize: CGFloat = 19
private let kWebViewFontWeight: Int = 300

class ArticleViewController: BaseViewController, UIScrollViewDelegate {
    
    var detailItem: AnyObject?
    var article = Article()
    var webView = UIWebView()
    
    var readabilityResult: ReadabilityResult?
    
    var headerView = ArticleHeaderView()
    var headerViewConstraints = Dictionary<String, NSLayoutConstraint>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        article.ArticleID > 0 ? setupArticle() : setupLandingPage()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        scrollViewDidScroll(webView.scrollView)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func resizeHeaderView () {
        
        headerViewConstraints["Height"]?.constant = kHeaderViewHeight
        view.animateConstraintChange(0.3)
    }
    
    func setupArticle() {
        
        setupWebView()
        setupHeaderView()
        
        view.showLoader()
        splitViewController?.toggleMasterView()
        webView.layer.opacity = 0
        
        article.getArticleText { (result) -> () in
            
            self.readabilityResult = result
            
            let css = "<style>  html, body {  -webkit-text-size-adjust: none; font-family: 'Apple SD Gothic Neo'; font-weight:\(kWebViewFontWeight); font-size: \(kWebViewFontSize)px } body { padding: \(kWebViewPadding)px; } img { max-width: 100%; } </style>"
            
            //div:first-of-type > img:first-child { display:none }
            
            var content = "<meta name=\"viewport\"> \(result.content)"
            content = content.replaceString("<body>", withString: "<body>\(css)")
            //content = content.replaceString(result.lead_image_url, withString: "")
            
            self.webView.loadHTMLString(content, baseURL: NSURL(string: result.url))
            
            self.headerView.headerViewConstraints = self.headerViewConstraints
            self.headerView.article = self.article
            self.headerView.readabilityResult = result
            self.headerView.setup()
            
            NSTimer.schedule(delay: 0.8) { timer in
                
                self.view.hideLoader()
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    
                    self.webView.layer.opacity = 1
                })
            }
        }
    }

    func setupWebView() {
        
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(webView)
        webView.fillSuperView(UIEdgeInsetsZero)
        
        webView.backgroundColor = UIColor.whiteColor()
        webView.scrollView.contentInset = UIEdgeInsets(top: kHeaderViewHeight + kHeaderViewMarginBottom, left: 0, bottom: 0, right: 0)
        webView.scrollView.delegate = self
    }
    
    func setupHeaderView() {
        
        headerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        webView.addSubview(headerView)
        
        headerViewConstraints["Top"] = headerView.addTopConstraint(toView: webView, relation: .Equal, constant: 0)
        headerView.addLeftConstraint(toView: webView, relation: .Equal, constant: 0)
        headerView.addRightConstraint(toView: webView, relation: .Equal, constant: 0)
        headerViewConstraints["Height"] = headerView.addHeightConstraint(relation: .Equal, constant: kHeaderViewHeight)
    }
    
    
    func setupLandingPage() {
        
        let button = UIButton()
        
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(button)
        button.fillSuperView(UIEdgeInsetsZero)
        
        button.backgroundColor = UIColor.blueColor()
        button.titleLabel?.font = UIFont.systemFontOfSize(23)
        button.setTitle("Click to start reading", forState: UIControlState.Normal)
        button.addTarget(self, action: "startReading", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func startReading() {
        
        splitViewController?.toggleMasterView()
    }

    
    //MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        headerView.scrollViewDidScroll(scrollView, headerOffset: headerView.frame.height + kHeaderViewMarginBottom)
        
        setNavigationBarAppearance(scrollView.contentOffset.y)
    }
    
    //MARK: - Animate navigation bar 
    
    func setNavigationBarAppearance(offset: CGFloat) {
        
        let y = offset + headerView.frame.height
        let condition = kHeaderViewHeight + kHeaderViewMarginBottom - (navigationController!.navigationBar.frame.height) - 64 + 20 + 4 //- headerView.titleHeight
        
        if y > condition{
            
            setNavigationBarDefault()
        }
        else {
            
            setNavigationBarTransparent()
        }
    }
}
