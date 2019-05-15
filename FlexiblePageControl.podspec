#
#  Be sure to run `pod spec lint FlexiblePageControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name          = "FlexiblePageControl"
  s.version       = "1.0.8"
  s.summary       = "FlexiblePageControl is flexible PageControl."

  s.description   = <<-DESC
This Framework is flexible PageControl like Instagram.
                    DESC

  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.homepage      = "https://github.com/shima11/FlexiblePageControl"
  s.author        = { "shima" => "shima.jin@icloud.com" }
  s.platform      = :ios, "8.0"
  s.swift_version = "5.0"
  s.source        = { :git => "https://github.com/shima11/FlexiblePageControl.git", :tag => "#{s.version}"}
  s.source_files  = "FlexiblePageControl", "FlexiblePageControl/**/*.{h,m,swift}"
end
