//
//  SwellHTTPConnection.swift
//  Swell
//
//  Created by Breckin Loggins on 6/8/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation
import CocoaHTTPServer

class SwellHTTPConnection : HTTPConnection {
    
    override func supportsMethod(method: String!, atPath path: String!) -> Bool {
        let httpMethod = HTTPMethod.fromRaw(method)
        if !httpMethod {
            return false
        }
        
        if let (route, _) = matchForURI(path) {
            if let handler = RouteMap.sharedRouteMap.handlerForMethod(httpMethod!, route: route.path) {
                return true
            }
        }
        
        return false
    }
    
    override func expectsRequestBodyFromMethod(method: String!, atPath path: String!) -> Bool {
        if method == "POST" {
            return true
        } else {
            return false
        }
    }
    
    override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        println("Will return response for \(method) -> \(path)")
        let httpMethod = HTTPMethod.fromRaw(method)
        if !httpMethod {
            return nil // TODO: 404
            
        }
        
        if let (route, params) = matchForURI(path) {
            if let handler = RouteMap.sharedRouteMap.handlerForMethod(httpMethod!, route: route.path) {
                var body = NSString(data: requestBody(), encoding: NSUTF8StringEncoding)
                HandlerContext.currentContext.params = params
                Params.parseParamsInBody(body)
                
                var response : HTTPDataResponse? = nil
                if let data = handler() as? NSString {
                    response = HTTPDataResponse(data:data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
                }
                HandlerContext.currentContext.params = [:] // So we don't keep them around after they are valid
                return response!
            }
        }
        
        return nil // TODO: 404
    }
    
    override func processBodyData(postDataChunk: NSData!) {
        if !self.appendRequestData(postDataChunk) {
            println("Couldn't append data!")
        }
    }
}
