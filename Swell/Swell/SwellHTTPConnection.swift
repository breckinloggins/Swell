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
    override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        println("Will return response for \(method) -> \(path)")
        let httpMethod = HTTPMethod.fromRaw(method)
        if !httpMethod {
            return nil // TODO: 404
            
        }
        
        if let (route, params) = matchForURI(path) {
            if let handler = RouteMap.sharedRouteMap.handlerForMethod(httpMethod!, route: route.path) {
                HandlerContext.currentContext.params = params
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
}
