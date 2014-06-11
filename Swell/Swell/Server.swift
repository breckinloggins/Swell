//
//  Server.swift
//  Swell
//
//  Created by Breckin Loggins on 6/11/14.
//  Copyright (c) 2014 Breckin Loggins. All rights reserved.
//

import Foundation
import CocoaHTTPServer

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