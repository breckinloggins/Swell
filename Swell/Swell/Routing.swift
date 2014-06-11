//
//  Routing.swift
//  Swell
//
//  Created by Breckin Loggins on 6/10/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

func _matchSpecForRoute(route: NSURL) -> NSURL
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

func _routeForURI(URI: String) -> NSURL? {
    let url = NSURL.URLWithString(URI)
    let urlComponents = url.pathComponents
    for route in RouteMap.sharedRouteMap.routes {
        if route.pathComponents.count != urlComponents.count {
            continue
        }
        let spec = _matchSpecForRoute(route)
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
    if let route = _routeForURI(URI) {
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

//
// Public DSL
//

func get(route: String, handler: () -> AnyObject?) {
    RouteMap.sharedRouteMap.registerRoute(route, forMethod: .GET, withHandler: handler)
}

func post(route: String, handler: () -> AnyObject?) {
    RouteMap.sharedRouteMap.registerRoute(route, forMethod: .POST, withHandler: handler)
}

func put(route: String, handler: () -> AnyObject?) {
    RouteMap.sharedRouteMap.registerRoute(route, forMethod: .PUT, withHandler: handler)
}

func delete(route: String, handler: () -> AnyObject?) {
    RouteMap.sharedRouteMap.registerRoute(route, forMethod: .DELETE, withHandler: handler)
}