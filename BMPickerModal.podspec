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
  s.version          = "1.0.0"
  s.summary          = "BMPickerModal is a control showing a UIPicker or a UIDatePicker in a modal view."
  s.description      = <<-DESC

                       DESC
  s.homepage         = "https://github.com/blackmirror-media/BMPickerModal"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Adam Eri" => "adam.eri@blackmirror-media.co.uk" }
  s.source           = { :git => "https://github.com/blackmirror-media/BMPickerModal.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BMPickerModal' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
