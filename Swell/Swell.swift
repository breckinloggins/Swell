//
//  Swell.swift
//  Swell
//
//  Created by Breckin Loggins on 6/6/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation
import CocoaHTTPServer

var routes : NSURL[] = []

func matchSpecForRoute(route: NSURL) -> NSURL
{
    var specURL = NSURL.URLWithString("/")
    for component : AnyObject in route.pathComponents {
        if component as String == "/" {
            continue
        } else if component.hasPrefix(":") {
            specURL = specURL.URLByAppendingPathComponent(":")
        } else {
            specURL = specURL.URLByAppendingPathComponent(component as String)
        }
    }
    
    return specURL
}

func routeForURI(URI: String) -> NSURL? {
    let url = NSURL.URLWithString(URI)
    let urlComponents = url.pathComponents
    for route in routes {
        if route.pathComponents.count != urlComponents.count {
            continue
        }
        let spec = matchSpecForRoute(route)
        let specComponents = spec.pathComponents
        var i = 0
        for i = 0; i < specComponents.count; i++ {
            let urlComponent = urlComponents[i] as String
            let specComponent = specComponents[i] as String
            
            if urlComponent == specComponent {
                continue
            }
            
            if specComponent != ":" {
                break
            }
        }
        
        if i == specComponents.count {
            // Got all the way through, this route matches
            return route
        }
    }
    
    return nil
}

func matchForURI(URI : String) -> (NSURL, Dictionary<String, String>)? {
    if let route = routeForURI(URI) {
        var params : Dictionary<String, String> = [:]
        let url = NSURL.URLWithString(URI)
        let urlComponents = url.pathComponents
        let routeComponents = route.pathComponents
        for var i = 0; i < urlComponents.count; i++ {
            let routeComponent = routeComponents[i] as String
            if routeComponent.hasPrefix(":") {
                params[routeComponent.substringFromIndex(1)] = urlComponents[i] as? String
            }
        }
        
        return (route, params)
    }
    
    return nil
}

class SwellHTTPConnection : HTTPConnection {
    override func httpResponseForMethod(method: String!, URI path: String!) -> NSObject! {
        println("Will return response for \(method) -> \(path)")
        if let (route, params) = matchForURI(path) {
            let handler = routeMap[route]!
            NSThread.currentThread().threadDictionary["params"] = params
            let response = HTTPDataResponse(data:handler().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
            NSThread.currentThread().threadDictionary.removeObjectForKey("params")
            return response
        }
        
        return nil // TODO: 404
    }
}

class Params {
    subscript(key : String) -> String? {
        if let params = NSThread.currentThread().threadDictionary["params"] as? Dictionary<String, String> {
            return params[key]
        }
            
        return nil
    }
}

var routeMap : Dictionary<NSURL, () -> String> = [:]
var params = Params()

func get(route : String, handler : () -> String) {
    let routeURL = NSURL.URLWithString(route)
    routeMap[routeURL] = handler
    routes.append(routeURL)
}

func listen(port : Int) {
    let server = HTTPServer()
    server.setConnectionClass(SwellHTTPConnection)
    
    println("Server starting on port \(port)")
    server.setPort(UInt16(port))
    
    let error : NSErrorPointer = nil
    server.start(error)
    
    if error {
        println("Error starting server: \(error)")
    }
    
    NSRunLoop.currentRunLoop().run()
}