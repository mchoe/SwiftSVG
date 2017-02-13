

Pod::Spec.new do |s| 

  s.name         = "SwiftSVG"
  s.version      = "1.3.1"
  s.summary      = "A simple SVG parser written in Swift"
  s.description  = "A single pass, performant SVG parser with multiple interface options including UI/NSBezierPath, CAShapeLayer, and UI/NSView"
  s.homepage     = "https://github.com/mchoe/SwiftSVG"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Michael Choe" => "michael@straussmade.com" }
  s.social_media_url = "http://twitter.com/_mchoe"
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/mchoe/SwiftSVG.git", :tag => "v#{s.version}" }
  s.source_files  = "SwiftSVG", "SwiftSVG/**/*.{h,swift}"

end
