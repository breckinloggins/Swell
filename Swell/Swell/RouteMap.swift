//
//  RouteMap.swift
//  Swell
//
//  Created by Breckin Loggins on 6/8/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

var _routeMapInstance = RouteMap()

class RouteMap {
    class var sharedRouteMap : RouteMap {
        return _routeMapInstance
    }
    
    var _map : Dictionary<NSURL, Dictionary<HTTPMethod, () -> AnyObject?>> = [:]
    
    var routes : NSURL[] {
        return NSURL[](_map.keys)
    }
    
    func registerRoute(route: String, forMethod method: HTTPMethod, withHandler handler: () -> AnyObject?) {
        let routeURL = NSURL.URLWithString(route)
        if var handlerMap = _map[routeURL] {
            handlerMap[method] = handler
            _map[routeURL] = handlerMap
        } else {
            _map[routeURL] = [method: handler]
        }
    }
    
    func handlerForMethod(method : HTTPMethod, route : String) -> (() -> AnyObject?)? {
        let routeURL = NSURL.URLWithString(route)
        if let handlerMap = _map[routeURL] {
            return handlerMap[method]
        }
        
        return nil
    }
}