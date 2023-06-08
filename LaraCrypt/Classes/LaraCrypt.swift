//
//  LaraCrypt.swift
//  LaraCrypt
//
//  Created by Fardad Co
//  Copyright © 2017 Fardad Co. All rights reserved.
//

import UIKit
import CryptoKit
import CommonCrypto

extension Data {
    //MARK: Converting string to Hex
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

extension String {
    func indexer(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substr(from: Int) -> String {
        let fromIndex = indexer(from: from)
        return substring(from: fromIndex)
    }
    
    func substr(to: Int) -> String {
        let toIndex = indexer(from: to)
        return substring(to: toIndex)
    }
    
    func substr(with r: Range<Int>) -> String {
        let startIndex = indexer(from: r.lowerBound)
        let endIndex = indexer(from: r.upperBound)
        return substring(with: startIndex..<endIndex)
    }
}














public class LaraCrypt: NSObject {
    
    //MARK: Generating random string with 16 char length
    func generateRandomBytes() -> String? {
        var keyData = Data(count: 10)
        let bytes = keyData.withUnsafeMutableBytes { pointer -> UnsafeMutablePointer<UInt8>? in
            if let bytes = pointer.bindMemory(to: UInt8.self).baseAddress {
                return bytes
            }
            return nil
        }
        guard let bytes = bytes else { return nil }
        let result = SecRandomCopyBytes(kSecRandomDefault, keyData.count, bytes)
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            print("Problem generating random bytes")
            return nil
        }
    }
    
    //MARK: Converting data format to array of UInt8
    func DATA_TO_UINT8(_ d:Data) -> Array<UInt8> {
        return d.withUnsafeBytes {
            [UInt8](UnsafeBufferPointer(start: $0, count: (d.count)))
        }
    }
    
    //MARK: Converting string to JSON model
    func stringSerilizer(String str:String) -> String {
        return String(format:"s:%lu:\"%@\";",str.count,str)
    }
    
    //MARK: Converting JSON to string model
    func stringUnserilizer(String str:String) -> String {
        var index:Int  = 0
        for (i,char) in str.enumerated() {
            if char == "\"" {
                index = i
                break
            }
        }
        let stringChangedA:String = str.substr(from: index+1)
        let stringChangedB:String = stringChangedA.substr(to: stringChangedA.count-2)
        return stringChangedB
    }
    
    //MARK: Converting JSON to Dictionary model
    func convertToDictionary(text: String) -> [String: String]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    //MARK: Making hmac like hash_hmac in PHP
    func HMAC_CREATOR(MIX_STR mixStr:String,KEY_DATA_UINT8 keyDataUint8:Array<UInt8>) -> String {
        let signatureData : Data = mixStr.data(using: .utf8)!
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity:Int(CC_SHA256_DIGEST_LENGTH))
        var hmacContext = CCHmacContext()
        CCHmacInit(&hmacContext, CCHmacAlgorithm(kCCHmacAlgSHA256), (keyDataUint8), (keyDataUint8.count))
        CCHmacUpdate(&hmacContext, [UInt8](signatureData), [UInt8](signatureData).count)
        CCHmacFinal(&hmacContext, digest)
        let macData = Data(bytes: digest, count: Int(CC_SHA256_DIGEST_LENGTH))
        return  macData.hexEncodedString()
    }
    
    //MARK: Encrypting data with AES-256-CBC method
    func AES256CBC(data:Data, keyData:Data, ivData:Data, operation:Int) -> Data {
        
        let cryptLength  = size_t(data.count + kCCBlockSizeAES128)
        var cryptData = Data(count:cryptLength)
        
        let keyLength             = size_t(kCCKeySizeAES256)
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted :size_t = 0
        
        let cryptStatus = cryptData.withUnsafeMutableBytes {cryptBytes in
            data.withUnsafeBytes {dataBytes in
                ivData.withUnsafeBytes {ivBytes in
                    keyData.withUnsafeBytes {keyBytes in
                        CCCrypt(CCOperation(operation),
                                CCAlgorithm(kCCAlgorithmAES),
                                options,
                                keyBytes, keyLength,
                                ivBytes,
                                dataBytes, data.count,
                                cryptBytes, cryptLength,
                                &numBytesEncrypted)
                    }
                }
            }
        }
        
        if UInt32(cryptStatus) == UInt32(kCCSuccess) {
            cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
            
        } else {
            print("Error: \(cryptStatus)")
        }
        
        return cryptData;
    }
    
    //MARK: Laravel encryption method
    public func encrypt(Message message:String,Key key:String) -> String {
        
        //Preparing initial data
        let serilizedMessage  = stringSerilizer(String: message)
        let serilizedMessageData:Data = serilizedMessage.data(using: .utf8)!
        let keyData:Data      = Data(base64Encoded: key)!
        let keyDataUint8      = DATA_TO_UINT8(keyData)
        let iv  :String       = generateRandomBytes()!
        let ivBase6Str:String = Data(iv.utf8).base64EncodedString()
        let ivData:Data = iv.data(using: .utf8)!
        
        //Encrypting data
        let encData = AES256CBC(data: serilizedMessageData, keyData: keyData, ivData: ivData, operation: kCCEncrypt)
        
        //Converting encrypted data to base64
        let encDataBase64Str = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        //Mixing base64 iv with base64 encrypted data
        let mixStr:String =  String(format:"%@%@",ivBase6Str,encDataBase64Str)
        
        //Creating Hmac from mixed string
        let macHexStr:String = HMAC_CREATOR(MIX_STR: mixStr, KEY_DATA_UINT8: keyDataUint8)
        
        //Combinig base64 iv with base64 encrypted data and Hmac
        let combineDict:Dictionary = ["iv":ivBase6Str,"value":encDataBase64Str,"mac":macHexStr]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: combineDict, options: .init(rawValue: 0))
            let jsonBase64Str_ENCRYPTED:String = jsonData.base64EncodedString()
            return jsonBase64Str_ENCRYPTED
        } catch {
            print(error.localizedDescription)
            return (error.localizedDescription)
        }
        
    }
    
    //MARK: Laravel decryption method
    public func decrypt(Message message:String,Key key:String) -> String {
        
        //Preparing initial data
        let keyData:Data = Data(base64Encoded: key)!
        let messageDecodedData = NSData(base64Encoded: message, options:.ignoreUnknownCharacters)
        let messageDecodedString = NSString(data: messageDecodedData! as Data, encoding: String.Encoding.utf8.rawValue)
        
        //Combinig base64 iv with base64 encrypted data and Hmac
        let combineDict:Dictionary = convertToDictionary(text: messageDecodedString! as String)!
        
        //IV
        let ivStr:String = combineDict["iv"]!
        let ivData:Data = Data(base64Encoded: ivStr)!
        
        //Value
        let value:String = combineDict["value"]!
        let valueData:Data =  Data(base64Encoded: value)!
        
        //Decrypting data
        let decData = AES256CBC(data: valueData, keyData: keyData, ivData: ivData, operation: kCCDecrypt)
        
        //Decrypted UInt8
        let decDataUInt8:Array<UInt8> = DATA_TO_UINT8(decData)
        
        //Decrypted Data
        let decAsData = NSData(bytes: decDataUInt8 as [UInt8], length: decDataUInt8.count)
        
        //Serialized Decrypted Message
        let deceSrializedString:String = String(data: decAsData as Data, encoding: String.Encoding.utf8)!
        
        //Unserialized Decrypted Message
        let decrypted:String = stringUnserilizer(String: deceSrializedString)
        
        
        return decrypted
    }
    
    
    
    
}
