#
# Be sure to run `pod lib lint AwesomeTextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AwesomeTextField'
  s.version          = '0.1.0'
  s.summary          = 'AwesomeTextField is a UITextField with sliding-up placeholder while editing'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Awesome TextField is a nice and simple library for iOS and Mac OSX. It's highly customizable and easy-to-use tool. Works perfectly for any registration or login forms in your app.
                       DESC

  s.homepage         = 'https://github.com/aleksandrshoshiashvili/AwesomeTextFieldSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'NikoGenn' => 'nikogenn96@mail.ru' }
  s.source           = { :git => 'https://github.com/aleksandrshoshiashvili/AwesomeTextFieldSwift.git', :tag => 'v0.1.0' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AwesomeTextField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AwesomeTextField' => ['AwesomeTextField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
