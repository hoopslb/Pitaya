//
//  PitayaTests.swift
//  PitayaTests
//
//  Created by JohnLui on 15/5/14.
//  Copyright (c) 2015年 http://lvwenhan.com. All rights reserved.
//

import UIKit
import XCTest
import Pitaya

class PitayaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testBaseRequest() {
        // Basic GET and POST
        Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == "", "GET should success and return empty string with no params")
        }
        Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == "", "POST should success and return empty string with no params")
        }
    }
    
    func testRequestWithParams() {
        // GET and POST with params
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        Pitaya.request(.GET, "http://pitayaswift.sinaapp.com/pitaya.php", ["get": param1, "get2": param2], { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
        }
        Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", ["post": param1, "post2": param2], { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == param1 + param2, "POST should success and return the strings together")
        }
    }
    func testFileUpload() {
        /* --------------------------
        *    NOTICE: you must copy Pitaya.png in "Supporting Files" directory to /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Agents
        *  --------------------------
        */
        let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!)!)
        Pitaya.request(.POST, "http://pitayaswift.sinaapp.com/pitaya.php", files: [file], { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == "1", "file upload")
        }
    }
    
    func testAuth() {
        let pitaya = PitayaManager.build(.GET, url: "http://httpbin.org/basic-auth/user/passwd")
        pitaya.fireWithBasicAuth(("user", "passwd"), errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
        }) { (string) -> Void in
        }
    }
    
    func testAddParamsFunction() {
        let param1 = randomStringWithLength(200)
        let param2 = randomStringWithLength(200)
        
        var pitaya = PitayaManager.build(.GET, url: "http://pitayaswift.sinaapp.com/pitaya.php")
        pitaya.addParams(["get": param1, "get2": param2])
        pitaya.fire(errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == param1 + param2, "GET should success and return the strings together")
        }
        
        pitaya = PitayaManager.build(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php")
        pitaya.addParams(["post": param1, "post2": param2])
        pitaya.fire(errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == param1 + param2, "POST should success and return the strings together")
        }
    }
    
    func testAddFilesFunction() {
        let pitaya = PitayaManager.build(.POST, url: "http://pitayaswift.sinaapp.com/pitaya.php")
        let file = File(name: "file", url: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pitaya", ofType: "png")!)!)
        pitaya.addFiles([file])
        pitaya.fire(errorCallback: { (error) -> Void in
            XCTAssert(false, error.localizedDescription)
            }) { (string) -> Void in
                XCTAssert(string == "1", "file upload")
        }
    }
    
    func testWait() {
        sleep(5) // wait Network for 5 seconds
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    func randomStringWithLength(len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789我就测试一下UTF-8"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString as String
    }
    
}
