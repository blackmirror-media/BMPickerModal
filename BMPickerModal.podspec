#
# Be sure to run `pod lib lint BMPickerModal.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BMPickerModal"
  s.version          = "1.1.1"
  s.summary          = "BMPickerModal is a control showing a UIPicker or a UIDatePicker in a modal view."
  s.description      = <<-DESC
                        BMPickerModal is an iOS drop-in class that displays a UIPicker or a UIDatePicker as modal view or in a popover controller on the iPad. Used to let the user select from a list of data or pick a date without leaving the current screen. Closures allow easy customisation.
                       DESC
  s.homepage         = "https://github.com/blackmirror-media/BMPickerModal"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Adam Eri" => "adam.eri@blackmirror.media" }
  s.source           = { :git => "https://github.com/blackmirror-media/BMPickerModal.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
