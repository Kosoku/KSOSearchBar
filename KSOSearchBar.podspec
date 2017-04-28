#
# Be sure to run `pod lib lint ${POD_NAME}.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KSOSearchBar'
  s.version          = '0.1.0'
  s.summary          = 'KSOSearchBar is an alternative implementation of UISearchBar.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
KSOSearchBar is an alternative implementation of UISearchBar. The goal being to avoid the litany of graphical and layout issues present in UISearchBar.
                       DESC

  s.homepage         = 'https://github.com/Kosoku/KSOSearchBar'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'license.txt' }
  s.author           = { 'William Towe' => 'willbur1984@gmail.com' }
  s.source           = { :git => 'https://github.com/Kosoku/KSOSearchBar.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  
  s.requires_arc = true

  s.source_files = 'KSOSearchBar/**/*.{h,m}'
  
  s.resource_bundles = {
    'KSOSearchBar' => ['KSOSearchBar/**/*.{xcassets,lproj}']
  }

  s.frameworks = 'UIKit'
  
  s.dependency 'KSOFontAwesomeExtensions'
  s.dependency 'Ditko'
  s.dependency 'Stanley'
end
