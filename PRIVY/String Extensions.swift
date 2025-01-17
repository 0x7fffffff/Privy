//
//  StringExt.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/10/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit
import RNCryptor


protocol StringType { var get: String { get } }
extension String: StringType { var get: String { return self } }

extension Optional where Wrapped: StringType {
    var isNilOrEmpty: Bool {
        return self == nil || self!.get.isEmpty
    }
}

extension String {
    
    static func mediumDateShortTime(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = .currentLocale()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    static func mediumDateNoTime(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = .currentLocale()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    static func fullDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = .currentLocale()
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .FullStyle
        return dateFormatter.stringFromDate(date)
    }
}

extension String {
    /**
     <#Description#>

     - parameter string: <#string description#>

     - returns: <#return value description#>
     */
    func md5() -> String {
        var digest = [UInt8](
            count: Int(CC_MD5_DIGEST_LENGTH),
            repeatedValue: 0
        )

        if let data = dataUsingEncoding(NSUTF8StringEncoding) {
            CC_MD5(data.bytes, CC_LONG(data.length), &digest)
        }

        return (0 ..< Int(CC_MD5_DIGEST_LENGTH))
            .reduce("") {
                $0 + String(format: "%02x", $1)
        }
    }
}
