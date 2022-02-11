#
# Be sure to run `pod lib lint LaraCrypt.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'LaraCrypt'
s.version          = '0.1.6'
s.summary          = 'Laravel encryption and decryption method for Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
Laravel encryption and decryption method with using AES-256-CBC and base64 key for Swift.
DESC

s.homepage         = 'https://github.com/FardadCo/LaraCrypt'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'FardadCo' => 'developers@fardad.co' }
s.source           = { :git => 'https://github.com/FardadCo/LaraCrypt.git', :tag => s.version.to_s }
s.source_files  = ["LaraCrypt/Classes/*.swift", "LaraCrypt/Classes/LaraCrypt.swift"]
s.ios.deployment_target = '9.0'

s.social_media_url = 'https://twitter.com/fardadco'


s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
s.source_files = 'LaraCrypt/Classes/**/*'

# s.resource_bundles = {
#   'SayHello6' => ['LaraCrypt/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
