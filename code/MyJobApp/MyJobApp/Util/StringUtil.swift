// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

class StringUtil {
    
   private static let emailRegEx = "^[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}$"
    
   class func sizeCheck(string: String? , minSize: Int  , maxSize : Int ) -> Bool {
        guard let str = string else {
            return false
        }
        if str.count >= minSize && str.count <= maxSize {
            return true
        } else {
            return false
        }
    }
    
    class func isValidEmailAddress(emailAddressString: String) -> Bool {
        var returnValue = true
        do {
            let regex = try NSRegularExpression(pattern: StringUtil.emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        return  returnValue
    }
    
}
