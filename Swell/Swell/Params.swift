//
//  Params.swift
//  Swell
//
//  Created by Breckin Loggins on 6/10/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

class Params {
    subscript(key: String) -> String? {
        return HandlerContext.currentContext.params[key]
    }
}

let params = Params()