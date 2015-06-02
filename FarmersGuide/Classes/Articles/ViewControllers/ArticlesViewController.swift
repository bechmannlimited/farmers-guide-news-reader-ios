//
//  ArticlesViewController.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 30/05/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

class ArticlesViewController: BaseViewController {

    var tableView = UITableView()
    var articles = [Article]()
    var selectedArticle = Article() // temp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView(tableView, delegate: self, dataSource: self)
        tableView.registerClass(ArticleTableViewCell.self, forCellReuseIdentifier: "Cell")
        refresh(nil)
        
        title = "Articles"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            
            let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    override func refresh(refreshControl: UIRefreshControl?) {
        
        Article.webApiGetMultipleObjects(Article.self, completion: { (objects) -> () in
            
            self.articles = objects
            
        })?.onDownloadFinished({ () -> () in
            
            refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! ArticleViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            
            controller.article = selectedArticle
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! ArticleTableViewCell

        cell.article = articles[indexPath.row]
        cell.setup()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let article = articles[indexPath.row]
        selectedArticle = article
        
        performSegueWithIdentifier("showDetail", sender: self)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 80
    }
}
