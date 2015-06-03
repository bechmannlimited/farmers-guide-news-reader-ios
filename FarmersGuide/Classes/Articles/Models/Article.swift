//
//  Article.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//


import UIKit
import ABToolKit
import SwiftyJSON

class Article: JSONObject {
    
    var ArticleID: Int = 0
    var Title: String = ""
    var Subtitle: String = ""
    var ThumbnailName: String = ""
    var ArticleText: String = ""
    
    var Thumbnail: UIImage?
    
    // MARK: - Web api methods
    
    override func webApiRestObjectID() -> Int? {
        
        return ArticleID
    }
    
    override func registerClassesForJsonMapping() {
        
        self.registerProperty("ThumbnailName", withJsonKey: "Thumbnail")
    }
    
    override class func webApiGetMultipleObjects< T : JSONObject >(type: T.Type, completion: (objects:[T]) -> () ) -> JsonRequest? {
        
        let url = "http://www.bechmann.co.uk/fg/GetJSData.aspx?dt=CategoryArticles&id=1&start=1&rows=50"
        
        return JsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess { (json, request) -> () in
            
            var objects = [T]()
            
            for (index: String, objectJSON: JSON) in json {
                
                var object:T = self.createObjectFromJson(objectJSON)
                objects.append(object)
            }
            
            completion(objects: objects)
        }
    }
    
    func getArticleText(completion: (result: ReadabilityResult) -> ()) {
        
        ReadabilityResult.create("http://www.bechmann.co.uk/fg/GetJSData.aspx?id=\(ArticleID)", completion: { (result) -> () in
            
            completion(result: result)
        })
    }
    
    func getThumbnail(completion: () -> ()) {
        
        ImageLoader.sharedLoader().imageForUrl("http://www.farmersguide.co.uk/content/img/thumbs/\(ThumbnailName)", completionHandler: { (image, url) -> () in
            
            self.Thumbnail = image
            completion()
        })
    }
}