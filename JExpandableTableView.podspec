#
# Be sure to run `pod lib lint JExpandableTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JExpandableTableView'
  s.version          = '0.1.1'
  s.summary          = 'Usefull enhancements with UITableView to support expand/collapsable cells'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'JExpandableTableView provides out of box support for expandable table cells'

  s.homepage         = 'https://github.com/jadhavp/JExpandableTableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jadhavp' => 'jadhav.pramod.a@gmail.com' }
  s.source           = { :git => 'https://github.com/jadhavp/JExpandableTableView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'JExpandableTableView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JExpandableTableView' => ['JExpandableTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
