#
# Be sure to run `pod lib lint HHPGNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HHPGNetWork'
  s.version          = '0.1.0'
  s.summary          = 'RxSwift & Alamofire 网络库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: RxSwift封装络请求封， 包含了网络请求，数据解析.
                       DESC

  s.homepage         = 'https://github.com/liufengjun/HHPGNetWork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liufengjun' => '2546863989@qq.com' }
  s.source           = { :git => 'https://github.com/liufengjun/HHPGNetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HHPGNetWork/Classes/**/*'
  s.dependency 'RxSwift', '~> 4.1.2'
  s.dependency 'RxCocoa', '~> 4.1.2'
  s.dependency 'Alamofire', '~> 4.7.0'
  s.dependency 'Result', '~> 3.2.4'
  
  # s.resource_bundles = {
  #   'HHPGNetWork' => ['HHPGNetWork/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
