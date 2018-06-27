//
//  Util.swift
//  AwesomeNewsApp
//
//  Created by Yiming Dong on 2018/6/27.
//  Copyright © 2018 Yiming Dong. All rights reserved.
//

import Foundation

extension String {
    func toMD5()  -> String {
        
        if let messageData = self.data(using:String.Encoding.utf8) {
            var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
            
            _ = digestData.withUnsafeMutableBytes {digestBytes in
                messageData.withUnsafeBytes {messageBytes in
                    CC_MD5(messageBytes, CC_LONG((messageData.count)), digestBytes)
                }
            }
            return digestData.hexString()
        }
        
        return self
    }
}


extension Data {
    
    func hexString() -> String {
        let string = self.map{ String($0, radix:16) }.joined()
        return string
    }
    
}
