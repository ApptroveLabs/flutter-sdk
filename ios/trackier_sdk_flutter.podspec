#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint trackier_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'trackier_sdk_flutter'
  s.version          = '1.6.75'
  s.summary          = 'Trackier flutter SDK'
  s.description      = <<-DESC
This is Trackier flutter SDK
                       DESC
  s.homepage         = 'https://trackier.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Trackier Dev' => 'dev@trackier.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'trackier-ios-sdk'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
