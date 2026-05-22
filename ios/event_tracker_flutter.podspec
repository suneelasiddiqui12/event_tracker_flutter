Pod::Spec.new do |s|

  s.name             = 'event_tracker_flutter'
  s.version          = '1.0.0'
  s.summary          = 'Cross-platform Event Tracker SDK plugin for Flutter.'
  s.description      = 'A Flutter plugin for tracking events on Android and iOS.'
  s.homepage         = 'https://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Raqami' => 'support@example.com' }
  s.source           = { :path => '.' }

  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'

  s.platform         = :ios, '13.0'
  s.swift_version    = '5.0'

  s.vendored_frameworks =
    'Frameworks/EventTrackerSDK.xcframework'

end
