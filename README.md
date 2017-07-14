# LaraCrypt 0.1.x

[![Version](https://img.shields.io/cocoapods/v/LaraCrypt.svg?style=flat)](http://cocoapods.org/pods/LaraCrypt)
[![License](https://img.shields.io/cocoapods/l/LaraCrypt.svg?style=flat)](http://cocoapods.org/pods/LaraCrypt)
[![Platform](https://img.shields.io/cocoapods/p/LaraCrypt.svg?style=flat)](http://cocoapods.org/pods/LaraCrypt)
[![Language](https://img.shields.io/badge/language-swift-orange.svg)](https://swift.org/)
[![OS Version](https://img.shields.io/badge/made%20with-%3C3-orange.svg)](http://cocoapods.org/pods/LaraCrypt)

This is a function for encrypt and decrypt data such as Laravel encryption in Swift.

## Requirements

- iOS 9.0+
- Swift 3 (LaraCrypt 0.1.x)

## Installation

LaraCrypt is available through [CocoaPods](http://cocoapods.org). 
To install it, simply add the following line to your Podfile:

```ruby
pod 'LaraCrypt'
```

## Usage

There is a main public function in LaraCrypt calss:<br>
`encrypt` - For use this fucntion you should set two parameters contain base64 key with 44 characters length and your message as a string that you want to be encrypted  
`decrypt` - For use this fucntion you should set two parameters contain base64 key with 44 characters length and your encrypted message as a string that you want to be decrypted 
```ruby
let key : String = "u6KuXJLIUwEUl7noY8J8H1ffDRwLC/5gjaWW1qTQ3hE="
let message : String = "123456"
let encryptedString : String = LaraCrypt().encrypt(Message: message, Key: key)
let decryptedString : String = LaraCrypt().decrypt(Message: encryptedString, Key: key)
```

## Support

[Fardad Co](http://fardad.co)

## License

LaraCrypt is available under the MIT license. See the LICENSE file for more info.
