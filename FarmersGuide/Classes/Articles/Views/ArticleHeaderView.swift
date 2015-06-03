//
//  ArticleHeaderView.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 03/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kTitlePadding: CGFloat = 15
private let KHeroImageViewOpacityThreshold: CGFloat = 700

class ArticleHeaderView: UIView {

    var headerViewConstraints = Dictionary<String, NSLayoutConstraint>()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
    var heroImageView = UIImageView()
    var heroImageConstraints = Dictionary<String, NSLayoutConstraint>()
    
    var article = Article()
    var readabilityResult: ReadabilityResult?
    
    func setup() {
        
        setupHeroImage()
        getHeroImage()
        
        userInteractionEnabled = false
        blurView.layer.opacity = 1
    }
    
    func setupHeroImage() {
        
        heroImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(heroImageView)
        
        heroImageConstraints["Top"] = heroImageView.addTopConstraint(toView: self, relation: .Equal, constant: 0)
        heroImageConstraints["Left"] = heroImageView.addLeftConstraint(toView: self, relation: .Equal, constant: 0)
        heroImageConstraints["Right"] = heroImageView.addRightConstraint(toView: self, relation: .Equal, constant: 0)
        heroImageConstraints["Height"] = heroImageView.addHeightConstraint(relation: .Equal, constant: self.frame.height)
        
        heroImageView.contentMode = UIViewContentMode.ScaleAspectFill
        heroImageView.clipsToBounds = true
    }
    
    func getHeroImage() {
        
        if let url = readabilityResult?.lead_image_url {
            
            heroImageView.showLoader()
            
            ImageLoader.sharedLoader().imageForUrl(url, completionHandler: { (image, url) -> () in
                
                self.heroImageView.image = image
                self.heroImageView.hideLoader()
                
                self.setupHeroImageBlurView()
                self.setupTitle()
            })
        }
    }
    
    func setupHeroImageBlurView() {
        
        blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
        heroImageView.addSubview(blurView)
        blurView.fillSuperView(UIEdgeInsetsZero)
    }
    
    func setupTitle() {
        
        //TITLE
        var titleLabel = UILabel()
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(titleLabel)
        
        let font = Session.AppFont(25, weight: FontWithWeight.Bold)
        let height = UILabel.heightForLabel(article.Title, font: font, width: self.frame.width - (kTitlePadding * 2))

        titleLabel.addHeightConstraint(relation: .Equal, constant: height)
        titleLabel.addLeftConstraint(toView: self, relation: .Equal, constant: kTitlePadding)
        titleLabel.addRightConstraint(toView: self, relation: .Equal, constant: -kTitlePadding)
        titleLabel.addBottomConstraint(toView: heroImageView, attribute: NSLayoutAttribute.Bottom, relation: .Equal, constant: -kTitlePadding)

        titleLabel.text = article.Title
        titleLabel.font = font
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Left
    }

    func scrollViewDidScroll(extraImageHeight: CGFloat) {
        
        if extraImageHeight > 0 {
            
            headerViewConstraints["Top"]?.constant = 0
            heroImageConstraints["Height"]?.constant = self.frame.height + extraImageHeight
            heroImageConstraints["Left"]?.constant = -(extraImageHeight / 2)
            heroImageConstraints["Right"]?.constant = (extraImageHeight / 2)
        }
        else{
            
            headerViewConstraints["Top"]?.constant = extraImageHeight
            heroImageConstraints["Height"]?.constant = self.frame.height
            heroImageConstraints["Left"]?.constant = 0
            heroImageConstraints["Right"]?.constant = 0
        }
        
        let max:CGFloat = KHeroImageViewOpacityThreshold
        let percentage:CGFloat = (extraImageHeight / max ) * 100
        let percentageOpacity:CGFloat = (100 - percentage) / 100
        
        blurView.layer.opacity = Float(percentageOpacity)
    }
}
