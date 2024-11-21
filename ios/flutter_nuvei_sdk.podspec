#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_nuvei_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_nuvei_sdk'
  s.version          = '1.3.2'
  s.summary          = 'Nuvei Mobile SDK for flutter.'
  s.description      = <<-DESC
  Nuvei Mobile SDK for flutter.
                       DESC
  s.homepage         = 'https://exnodes.vn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Exnodes' => 'dragoon@exnodes.vn' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.vendored_frameworks = [
    'Frameworks/CryptoSwift.xcframework',
    'Frameworks/JOSESwift.xcframework',
    'Frameworks/NuveiSimplyConnectSDK.xcframework'
  ]

  s.dependency 'Alamofire', '5.7.1'
  s.dependency 'SwiftyJSON', '5.0.1'  
  s.dependency 'TinyConstraints', '4.0.2'
  s.dependency 'SDWebImage', '5.15.7'
end
