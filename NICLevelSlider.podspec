Pod::Spec.new do |s|

  s.name         = "NICLevelSlider"
  s.version      = "0.0.3"
  s.summary      = "A Level Slider for iOS, written in Swift."
  s.homepage     = "https://github.com/nicholaslin/LevelSlider"
  s.license     = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "nicholasLin" => "990215314@qq.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/nicholaslin/LevelSlider.git", :tag => s.version.to_s }
  s.source_files = 'NICLevelSliderDemo/NICLevelSliderDemo/srcs/*.swift'
  s.swift_version = '4.0'
end

