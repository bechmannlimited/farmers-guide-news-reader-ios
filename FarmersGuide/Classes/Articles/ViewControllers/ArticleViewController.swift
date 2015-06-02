//
//  ArticleViewController.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kHeroImageHeight:CGFloat = 200
private let kHeroImageMarginBottom: CGFloat = 10

class ArticleViewController: UIViewController, UIScrollViewDelegate {
    
    var detailItem: AnyObject?
    var article = Article()
    var webView = UIWebView()
    var heroImageView = UIImageView()
    var readabilityResult: ReadabilityResult?
    
    var heroImageConstraints = Dictionary<String, NSLayoutConstraint>()
    
    var contentOffsetCompensation = kHeroImageHeight + kHeroImageMarginBottom + 64
    
    override func viewDidLoad() {
        super.viewDidLoad()

        article.ArticleID > 0 ? setupArticle() : setupLandingPage()
    }
    
    func setupArticle() {
        
        setupWebView()
        setupHeroImage()
        
        view.showLoader()
        splitViewController?.toggleMasterView()
        webView.layer.opacity = 0
        
        article.getArticleText { (result) -> () in
            
            self.readabilityResult = result
            
            let css = "<style>  html, body { font-family: 'Apple SD Gothic Neo'; font-weight:300; font-size: 14pt } img { max-width: 100%; } div:first-of-type > img:first-child { display:none } </style>"
            
            var content = result.content
            content = content.replaceString("<body>", withString: "<body>\(css)")
            
            self.webView.loadHTMLString(content, baseURL: NSURL(string: result.url))
            
            self.getHeroImage()
            
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
        webView.scrollView.contentInset = UIEdgeInsets(top: kHeroImageHeight + kHeroImageMarginBottom, left: 0, bottom: 0, right: 0)
        
        webView.scrollView.delegate = self
    }
    
    func setupHeroImage() {
        
        heroImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        webView.addSubview(heroImageView)
        
        heroImageConstraints["Top"] = heroImageView.addTopConstraint(toView: webView, relation: .Equal, constant: 64)
        heroImageConstraints["Left"] = heroImageView.addLeftConstraint(toView: webView, relation: .Equal, constant: 0)
        heroImageConstraints["Right"] = heroImageView.addRightConstraint(toView: webView, relation: .Equal, constant: 0)
        heroImageConstraints["Height"] = heroImageView.addHeightConstraint(relation: .Equal, constant: kHeroImageHeight)
    }
    
    func getHeroImage() {
        
        if let url = readabilityResult?.lead_image_url {
            
            heroImageView.showLoader()
            
            ImageLoader.sharedLoader().imageForUrl(url, completionHandler: { (image, url) -> () in
                
                self.heroImageView.image = image
                self.heroImageView.hideLoader()
                
                //self.setupHeroImageBlurView()
            })
        }
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

    func setupHeroImageBlurView() {
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        heroImageView.addSubview(blurView)
        blurView.fillSuperView(UIEdgeInsetsZero)
        
        //TITLE
        var titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        heroImageView.addSubview(titleLabel)
        titleLabel.fillSuperView(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        
        titleLabel.text = article.Title
        titleLabel.font = Session.AppFont(35, weight: FontWithWeight.Regular)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        
    }
    
    //MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var extraImageHeight = -(scrollView.contentOffset.y + contentOffsetCompensation)
        
        if extraImageHeight > 0 {
            
            heroImageConstraints["Top"]?.constant = 64
            heroImageConstraints["Height"]?.constant = kHeroImageHeight + extraImageHeight
            heroImageConstraints["Left"]?.constant = -(extraImageHeight / 2)
            heroImageConstraints["Right"]?.constant = (extraImageHeight / 2)
        }
        else{

            heroImageConstraints["Top"]?.constant = extraImageHeight + 64
            heroImageConstraints["Height"]?.constant = kHeroImageHeight
            heroImageConstraints["Left"]?.constant = 0
            heroImageConstraints["Right"]?.constant = 0
        }
    }
}
