//
//  GCD.swift
//  CircleRipple
//
//  Created by Zhou Hao on 15/08/15.
//  Copyright © 2015年 Zeus. All rights reserved.
//

import Foundation

class GCD {
    
    class func async(block: ()->()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
    
    class func main(block: ()->()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    class func delay(delaySeconds: Double, block: ()->()) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delaySeconds * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
}
