//
//  Params.swift
//  Swell
//
//  Created by Breckin Loggins on 6/10/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

class Params {
    class func parseParamsInBody(body : String) {
        for entry in body.componentsSeparatedByString("&") {
            if entry == "" {
                continue
            }
            
            let kvp = entry.componentsSeparatedByString("=")
            if kvp.count == 1 {
                HandlerContext.currentContext.params[kvp[0]] = ""
            } else if kvp.count == 2 {
                var val = kvp[1]
                val = val.stringByReplacingOccurrencesOfString("+", withString: " ")
                HandlerContext.currentContext.params[kvp[0]] = val.stringByRemovingPercentEncoding
            }
        }
    }
    
    subscript(key: String) -> String? {
        return HandlerContext.currentContext.params[key]
    }
}

let params = Params()