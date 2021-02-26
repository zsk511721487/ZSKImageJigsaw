#
#  Be sure to run `pod spec lint ZSKImageJigsaw.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ZSKImageJigsaw"
  spec.version      = "0.0.3"
  spec.summary      = "拼图功能实现"
  # spec.description  = <<-DESC
  #                 DESC
  spec.homepage     = "https://github.com/zsk511721487/ZSKImageJigsaw.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "张少康" => "511721487@qq.com" }
  # spec.platform     = :ios
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/zsk511721487/ZSKImageJigsaw.git", :tag => spec.version }
  spec.resource  = "ZSKImageJiasaw.bundle"
  spec.source_files = "Source/*.swift"
  # spec.resources = "Resources/*.png"
  spec.requires_arc = true
  spec.frameworks = 'UIKit','AVFoundation','Photos','MobileCoreServices'
  spec.vendored_frameworks = "ZSKImageJiasaw.framework"
  spec.swift_version = '5.0'

end
