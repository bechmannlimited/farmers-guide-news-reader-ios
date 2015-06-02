//
//  Test.swift
//  jsonreaderoptimizations
//
//  Created by Alex Bechmann on 22/04/2015.
//  Copyright (c) 2015 Alex Bechmann. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


public class JsonRequest: NSObject {
    
    internal var urlString = ""
    internal var method: Alamofire.Method = .GET
    internal var parameters: Dictionary<String, AnyObject>?
    
    public var alamofireRequest: Request?
    
    internal var succeedDownloadClosures: [(json: JSON, request: JsonRequest) -> ()] = []
    internal var succeedContextClosures: [() -> ()] = []
    
    internal var failDownloadClosures: [(error: NSError, alert: UIAlertController) -> ()] = []
    internal var failContextClosures: [() -> ()] = []
    
    internal var finishDownloadClosures: [() -> ()] = []
    
    public class func create< T : JsonRequest >(urlString:String, parameters:Dictionary<String, AnyObject>?, method:Alamofire.Method) -> T {
        
        return JsonRequest(urlString: urlString, parameters: parameters, method: method) as! T
    }
    
    internal convenience init(urlString:String, parameters:Dictionary<String, AnyObject>?, method:Alamofire.Method) {
        self.init()
        
        self.urlString = urlString
        self.parameters = parameters
        self.method = method
        
        exec()
    }
    
    public func onDownloadSuccess(success: (json: JSON, request: JsonRequest) -> ()) -> Self {
        self.succeedDownloadClosures.append(success)
        return self
    }
    
    public func onContextSuccess(success: () -> ()) -> Self {
        self.succeedContextClosures.append(success)
        return self
    }
    
    
    public func onDownloadFailure(failure: (error: NSError, alert: UIAlertController) -> ()) -> Self {
        self.failDownloadClosures.append(failure)
        return self
    }
    
    public func onContextFailure(failure: () -> ()) -> Self {
        self.failContextClosures.append(failure)
        return self
    }
    
    
    public func onDownloadFinished(finished: () -> ()) -> Self {
        self.finishDownloadClosures.append(finished)
        return self
    }
    
    
    
    func succeedDownload(json: JSON) {
        
        for closure in self.succeedDownloadClosures {
            
            closure(json: json, request: self)
        }
    }
    
    public func succeedContext() {
        
        for closure in self.succeedContextClosures {
            
            closure()
        }
    }
    
    
    func failDownload(error: NSError, alert: UIAlertController) {
        
        for closure in self.failDownloadClosures {
            
            closure(error: error, alert: alert)
        }
    }
    
    public func failContext() {
        
        for closure in self.failContextClosures {
            
            closure()
        }
    }
    
    
    func finishDownload() {
        
        for closure in self.finishDownloadClosures {
            
            closure()
        }
    }
    
    
    internal func exec() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.alamofireRequest = Alamofire.request(method, urlString, parameters: parameters, encoding: ParameterEncoding.URL)
            .response{ (request, response, data, error) in
                
                if let e = error {
                    
                    var alert = self.alertControllerForError(e, completion: { (retry) -> () in
                        
                        if retry {
                            
                            self.cancel()
                            self.exec()
                        }
                    })
                    
                    self.failDownload(e, alert: alert)
                }
                    
                else{
                    
                    let json = JSON(data: data! as! NSData)
                    self.succeedDownload(json)
                }
                
                self.finishDownload()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
    
    internal func alertControllerForError(error: NSError, completion: (retry: Bool) -> ()) -> UIAlertController {
        
        let alertController = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            completion(retry: false)
        }
        alertController.addAction(cancelAction)
        
        let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default) { (action) in
            completion(retry: true)
        }
        alertController.addAction(retryAction)
        
        return alertController
    }
    
    public func cancel() {
        
        self.alamofireRequest?.cancel()
    }
    
}



