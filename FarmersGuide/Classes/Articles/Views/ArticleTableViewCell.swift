//
//  ArticleTableViewCell.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 30/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kPadding: CGFloat = 10
private let kUnderneathTitleMargin: CGFloat = 0
private let kTitleFont = Session.AppFont(17, weight: .Regular)
private let kDescriptionFont = Session.AppFont(15, weight: .Thin)

class ArticleTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    var titleLabelConstraints = [NSLayoutConstraint]()
    
    let descriptionLabel = UILabel()
    var descriptionLabelConstraints = [NSLayoutConstraint]()
    
    var article = Article()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height)
        
        if imageView?.image == nil {
            
            imageView?.showLoader()
        }
    }
    
    func setup() {
    
        imageView?.image = UIImage()
        
        setupConstraints()
        
        getImage()
        
        titleLabel.text = article.Title
        descriptionLabel.text = article.Subtitle
    }
    
    func setupConstraints() {
        
        contentView.removeConstraints(titleLabelConstraints)
        titleLabelConstraints = []
        
        descriptionLabel.removeConstraints(descriptionLabelConstraints)
        descriptionLabelConstraints = []
        
        setupTitleLabelConstraints()
        setupDescriptionLabelConstraints()
    }
    
    func setupTitleLabelConstraints() {
        
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(titleLabel)
        
        var leftConstraint = imageView?.image == nil ?
            titleLabel.addLeftConstraint(toView: contentView, relation: .Equal, constant: kPadding) :
            titleLabel.addLeftConstraint(toView: imageView, attribute: NSLayoutAttribute.Right, relation: .Equal, constant: kPadding)
            
        
        titleLabelConstraints = [
            titleLabel.addTopConstraint(toView: contentView, relation: .Equal, constant: kPadding),
            leftConstraint,
            titleLabel.addRightConstraint(toView: contentView, relation: .Equal, constant: -kPadding),
        ]
        
        titleLabel.numberOfLines = 0
        titleLabel.font = kTitleFont
        titleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let height = UILabel.heightForLabel(article.Title, font: kTitleFont, width: contentView.frame.width - (kPadding * 2))
        
        titleLabelConstraints.append(titleLabel.addHeightConstraint(relation: .Equal, constant: height))
    }
    
    func setupDescriptionLabelConstraints() {
        
        descriptionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addSubview(descriptionLabel)
        
        var leftConstraint = imageView?.image == nil ?
            descriptionLabel.addLeftConstraint(toView: contentView, relation: .Equal, constant: kPadding) :
            descriptionLabel.addLeftConstraint(toView: imageView, attribute: NSLayoutAttribute.Right, relation: .Equal, constant: kPadding)
        
        descriptionLabelConstraints = [
            descriptionLabel.addTopConstraint(toView: titleLabel, attribute: .Bottom, relation: .Equal, constant: kUnderneathTitleMargin),
            leftConstraint,
            descriptionLabel.addRightConstraint(toView: contentView, relation: .Equal, constant: -kPadding),
            descriptionLabel.addBottomConstraint(toView: contentView, relation: .Equal, constant: -kPadding)
        ]
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = kDescriptionFont
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
    
    func getImage() {
        
        imageView?.showLoader()
        
        article.getThumbnail { () -> () in
            
            self.imageView?.image = self.article.Thumbnail
            self.imageView?.hideLoader()
        }
    }
}


