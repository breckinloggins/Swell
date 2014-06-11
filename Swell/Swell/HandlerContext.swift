//
//  HandlerContext.swift
//  Swell
//
//  Created by Breckin Loggins on 6/8/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Cocoa
import CocoaHTTPServer

let kHandlerContextKey = "HandlerContext"

class HandlerContext {
    class var currentContext : HandlerContext {
        objc_sync_enter(kHandlerContextKey)
        var ctx = NSThread.currentThread().threadDictionary[kHandlerContextKey] as? HandlerContext
        if !ctx {
            ctx = HandlerContext()
            NSThread.currentThread().threadDictionary[kHandlerContextKey] = ctx
        }
        
        objc_sync_exit(kHandlerContextKey)
        return ctx!
    }
    
    var params : Dictionary<String, String> = [:]
}
