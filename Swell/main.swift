//
//  main.swift
//  Swell
//
//  Created by Breckin Loggins on 6/6/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

let users = [1 : "Bob", 2 : "Mary"]

get("/user/:id") {
    if let id = params["id"]?.toInt() {
        if let user = users[id] {
            return "User name is \"\(user)\""
        } else {
            return "No user by that ID"
        }
    }
    
    return "Malformed user ID"
}

listen(12345)
