#
# Be sure to run `pod lib lint CSSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CSSwift"
  s.version          = "0.1.0"
  s.summary          = "Parsing css in swift"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
A css parser written in swift.
                       DESC

  s.homepage         = "https://github.com/darkcl/CSSwift"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Yeung Yiu Hung" => "hkclex@gmail.com" }
  s.source           = { :git => "https://github.com/darkcl/CSSwift.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/darkcl_dev'

  s.platform     = :ios, '8.0'
  s.frameworks         = 'JavaScriptCore'
  s.requires_arc = true

  s.source_files = 'Classes/**/*'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Java​Script​Core'
  # s.dependency 'ObjectMapper', '~> 1.1.5'
end
