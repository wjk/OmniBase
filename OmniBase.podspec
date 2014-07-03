Pod::Spec.new do |s|
  s.name             = "OmniBase"
  s.version          = "0.1.0"
  s.summary          = "The core Omni open source framework."
  s.homepage         = "https://github.com/wjk/OmniBase"
  s.license          = { :type => 'Omni', :file => 'LICENSE' }
  s.author           = { "William Kent" => "https://github.com/wjk" }
  s.source           = { :git => "https://github.com/wjk/OmniBase.git", :tag => s.version.to_s }

  s.platform = :osx
  s.osx.deployment_target = '10.9'
  s.source_files = 'Pod/Classes'
  s.public_header_files = 'Pod/Classes/**/*.h'
  s.requires_arc = true
end
