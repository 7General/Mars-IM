#
# Be sure to run `pod lib lint MarsSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MarsSDK'
  s.version          = '1.1.0'
  s.summary          = 'A short description of MarsSDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/7General/Mars-IM'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wanghuizhou' => 'wanghuizhou@guazi.com' }
  s.source           = { :git => 'https://github.com/7General/Mars-IM.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'
  s.resource_bundles = {
      'MarsSDK' => ['MarsSDK/Assets/**']
  }
  

  s.source_files = 'MarsSDK/Classes/**/*'
  
  s.libraries = 'z','resolv.9'
  s.frameworks = 'CoreTelephony','SystemConfiguration','CoreGraphics','UIKit','AVFoundation'
  s.vendored_frameworks = 'MarsSDK/Frameworks/mars.framework'
  s.user_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lc++']}
  
  s.dependency 'Protobuf'
  
  

end
