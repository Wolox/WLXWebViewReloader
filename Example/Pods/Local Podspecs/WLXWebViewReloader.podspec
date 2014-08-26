#
# Be sure to run `pod lib lint WLXWebViewReloader.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require 'pathname'
require 'xcodeproj'

Pod::Spec.new do |s|

  s.name             = "WLXWebViewReloader"
  s.version          = "0.1.0"
  s.summary          = "A short description of WLXWebViewReloader."
  s.description      = <<-DESC
                       An optional longer description of WLXWebViewReloader

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/WLXWebViewReloader"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Guido Marucci Blas" => "guidomb@gmail.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/WLXWebViewReloader.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'WLXWebViewReloader' => ['Pod/Assets/*.png', 'Pod/Assets/*.html', 'Pod/Assets/*.js']
  }

  s.prepare_command = <<-CMD
    mkdir -p #{Dir.pwd}/scripts
    cp ./Pods/WLXWebViewReloader/Scripts/wvreloader.sh #{Dir.pwd}/scripts/wvreloader.sh
    cp ./Pods/WLXWebViewReloader/Scripts/example.config.json #{Dir.pwd}/.reloader.json
  CMD

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
