

Pod::Spec.new do |s| 

  s.name         = "SwiftSVG"
  s.version      = "2.1.2"
  s.summary      = "A simple, performant, single pass SVG parser"
  s.description  = "A simple, performant, single pass SVG parser. Optimized for extension and developer joy."
  s.homepage     = "https://github.com/mchoe/SwiftSVG"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Michael Choe" => "michael@straussmade.com" }
  s.social_media_url = "http://twitter.com/_mchoe"
  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/mchoe/SwiftSVG.git", :tag => "v#{s.version}" }
  s.source_files  = "SwiftSVG", "SwiftSVG/**/*.{h,swift}"

end
