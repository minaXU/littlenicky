//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create HTTP server.
let server = HTTPServer()

// Register your own routes and handlers
var routes = Routes()

routes.add(method: .get, uri: "/peng") { (request, response) in
//    do {
//        try response.setBody(json: ["peng" : "beauty" , "xu" : "handsome"])
//    }catch{
//        print("you are so kid")
//    }
    response.setBody(string: "月月你是最棒的，你要开心，我爱你")
    response.completed()
}

//routes.add(method: .get, uri: "/peng/{yue}/xu") { (request, response) in
//    do {
//        try response.setBody(json: request.urlVariables)
//    }catch{
//        print("you are so kid")
//    }
//    response.appendBody(string: "\(request.urlVariables["yue"])")
//    response.completed()
//}

//routes.add(method: .get, uri: "/peng/yue/**") { (request, response) in
//    // response.appendBody(string: "\(request.path)")
//    response.appendBody(string: request.urlVariables[routeTrailingWildcardKey]!)
//    response.completed()
//}

var api = Routes()
api.add(method: .get, uri: "/call1", handler: { _, response in
    response.setBody(string: "程序接口API版本v1已经调用")
    response.completed()
})
api.add(method: .get, uri: "/call2", handler: { _, response in
    response.setBody(string: "程序接口API版本v2已经调用")
    response.completed()
})

// API版本v1
var api1Routes = Routes(baseUri: "/v1")
// API版本v2
var api2Routes = Routes(baseUri: "/v2")

// 为API版本v1增加主调函数
api1Routes.add(routes: api)
// 为API版本v2增加主调函数
api2Routes.add(routes: api)
// 更新API版本v2主调函数
api2Routes.add(method: .get, uri: "/call2", handler: { _, response in
    response.setBody(string: "程序接口API版本v2已经调用第二种方法")
    response.completed()
})

// 将两个版本的内容都注册到服务器主路由表上
routes.add(routes: api1Routes)
routes.add(routes: api2Routes)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8080

// Set a document root.
// This is optional. If you do not want to serve static content then do not set this.
// Setting the document root will automatically add a static file handler for the route /**
server.documentRoot = "./webroot"

// Gather command line options and further configure the server.
// Run the server with --help to see the list of supported arguments.
// Command line arguments will supplant any of the values set above.
configureServer(server)

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
