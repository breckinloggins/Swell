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
var t = Todo()
t.title = "Get milk"
todos.append(t)

t = Todo()
t.title = "Walk dog"
todos.append(t)

get("/todos") {
    return render {
        html {
            body {
                p("Your TODO List")
                ul {
                    for (index, todo) in enumerate(todos.filter({!$0.done})) {
                        if (todo.done) {
                            continue
                        }
                        
                        li { a(href:"/todos/\(index)") { text(todo.title) } }
                    }
                }
                
                br()
                
                p("New TODO")
                form(method: "POST", action: "/todos") {
                    fieldset {
                        label(`for`:"title") { text("Title") }
                        input(type:"text", name:"title")
                        
                        input(type:"submit", name:"submit", value:"Create TODO")
                    }
                }
            }
        }
    }
}

get("/todos/:id") {
    if let id = params["id"]?.toInt() {
        return render {
            html {
                body {
                    if id < todos.count {
                        p("Todo \(id)")
                        p(todos[id].title)
                    } else {
                        p("Todo \(id) not found")
                    }
                    br()
                    a(href:"/todos", { text("All todos") })
                }
            }
        }
    } else {
        return "Improper TODO URL"
    }
}

post("/todos") {
    if let title = params["title"] {
        t = Todo()
        t.title = title
        todos.append(t)
    }
    
    return ""
}

listen(12346)
