Pod::Spec.new do |s|
  s.name = 'AXLoadingView'
  s.version = "1.0"
  s.license = 'MIT'
  s.summary = '极简的线形和环形进度条。'
  s.homepage = "http://xaoxuu.com"
  s.authors = { 'xaoxuu' => 'xaoxuu@gmail.com' }
  s.source = { :git => "https://github.com/xaoxuu/AXLoadingView.git", :tag => "#{s.version}", :submodules => false}
  s.ios.deployment_target = '8.0'

  s.source_files = 'AXLoadingView/*.{h,m}'

  s.requires_arc = true
end
