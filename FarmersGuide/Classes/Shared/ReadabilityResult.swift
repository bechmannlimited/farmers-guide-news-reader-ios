//
//  ReadabilityResult.swift
//  FarmersGuide
//
//  Created by Alex Bechmann on 02/06/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import ABToolKit

private let kApiToken: String = "f053bb2cb8175d288f1f8042642bde6672debbfb"

class ReadabilityResult: JSONObject {
    
    var domain = ""
    var url = ""
    var short_url = ""
    var author = ""
    var excerpt = ""
    var word_count = 0
    var total_pages = 0
    var content = ""
    var date_published = ""
    var dek = ""
    var lead_image_url = ""
    var title = ""
    var rendered_pages = 0
    
    class func create(urlToParse: String, completion: (result: ReadabilityResult) -> ()) {
        
        let url = "http://readability.com/api/content/v1/parser?url=\(urlToParse)&token=\(kApiToken)"
        
        JsonRequest.create(url, parameters: nil, method: .GET).onDownloadSuccess({ (json, request) -> () in
            
            let result: ReadabilityResult = ReadabilityResult.createObjectFromJson(json)
            completion(result: result)
        })
    }
}