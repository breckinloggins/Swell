//
//  HTML.swift
//  Swell
//
//  Created by Breckin Loggins on 6/16/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation

let kHTMLContextKey = "HTMLContext"

class HTMLContext {
    class var currentContext : HTMLContext {
        objc_sync_enter(kHTMLContextKey)
        var ctx = NSThread.currentThread().threadDictionary[kHTMLContextKey] as? HTMLContext
        if !ctx {
            ctx = HTMLContext()
            NSThread.currentThread().threadDictionary[kHTMLContextKey] = ctx
        }
        
        objc_sync_exit(kHTMLContextKey)
        return ctx!
    }
    
    var htmlLines : String[] = []
    
    func addLine(line : String) {
        htmlLines.append(line)
    }
}

func render(content : () -> ()) -> String {
    content()
    
    return HTMLContext.currentContext.htmlLines.reduce("", combine: {$0 + "\n" + $1})
}

func text(text : String) {
    HTMLContext.currentContext.addLine(text)
}

func html(inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.htmlLines = []
    h.addLine("<!doctype html>")
    h.addLine("<html lang=\"en\">")
    
    inner()
    
    h.addLine("</html>")
}

func body(inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<body>")
    
    inner()
    
    h.addLine("</body>")
}

func p(text : String) {
    let h = HTMLContext.currentContext
    h.addLine("<p>")
    h.addLine(text)
}

func br() {
    HTMLContext.currentContext.addLine("<br>")
}

func ul(inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<ul>")
    
    inner()
    
    h.addLine("</ul")
}

func li(inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<li>")
    
    inner()
    
    h.addLine("</li>")
}

func a(#href: String, inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<a href=\"\(href)\">")
    
    inner()
    
    h.addLine("</a>")
}

func form(id:String="", method:String="GET", action:String="", inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<form id=\"\(id)\" method=\"\(method)\" action=\"\(action)\">")
    
    inner()
    
    h.addLine("</form>")
}

func fieldset(inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<fieldset>")
    
    inner()
    
    h.addLine("</fieldset>")
}

func label(#`for`:String, inner : () -> ()) {
    let h = HTMLContext.currentContext
    h.addLine("<label for=\"\(`for`)\">")
    
    inner()
    
    h.addLine("</label>")
}

func input(id:String="", type:String="", name:String="", value:String="") {
    HTMLContext.currentContext.addLine("<input id=\"\(id)\" type=\"\(type)\" name=\"\(name)\" value=\"\(value)\">")
}

