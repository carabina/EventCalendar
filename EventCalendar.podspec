Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "EventCalendar"
s.summary = "Allows the user to quickly create a calendar for events."
s.requires_arc = true

s.version = "0.1.2"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Tommy Martin" => "tm1291@messiah.edu" }

s.homepage = "https://github.com/tdmartin4/EventCalendar"

s.source = { :git => "https://github.com/tdmartin4/EventCalendar.git", :tag => "#{s.version}"}

s.framework = "UIKit"

s.source_files = "EventCalendar/**/*.{swift}"

s.resources = "EventCalendar/**/*.{png,jpeg,jpg,storyboard,xib}"
end
