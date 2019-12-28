#
# Be sure to run `pod lib lint HHPGNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HHPGNetWork'
  s.version          = '0.2.2'
  s.summary          = 'RxSwift & Alamofire 网络库'
  s.description      = <<-DESC
TODO: RxSwift封装络请求封， 包含了网络请求，数据解析.
                       DESC
  s.homepage         = 'https://github.com/manfengjun/HHPGNetWork'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'manfengjun' => 'chinafengjun@gmail.com' }
  s.source           = { :git => 'https://github.com/manfengjun/HHPGNetWork.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.swift_versions = '5.1'

  s.subspec 'Core' do |c|
      c.dependency 'Moya'
      c.source_files = 'HHPGNetWork/Classes/Core/**/*'
  end
  s.subspec 'Rx' do |r|
      r.dependency "HHPGNetWork/Core"
      r.dependency 'Moya/RxSwift'
      s.dependency 'RxCocoa'
      r.source_files = 'HHPGNetWork/Classes/Rx/**/*'
  end
  s.dependency 'HandyJSON'
end
