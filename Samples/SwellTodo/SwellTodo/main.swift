//
//  main.swift
//  SwellTodo
//
//  Created by Breckin Loggins on 6/11/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation
import Swell

class Todo {
    var title = ""
    var done = false
}

var todos : Todo[] = []

get("/todos") {
    return "<ul><li>Coffee</li><li>Milk</li></ul>"
}

get("/todos/:id") {
    if let id = params["id"] {
        return "TODO \(id)"
    } else {
        return "Nope"
    }
}

listen(12346)
