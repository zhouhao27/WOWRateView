Pod::Spec.new do |s|
  s.name             = 'WOWRateView'
  s.version          = '0.1.0'
  s.summary          = 'Swift version of UIView to show rate.'

  s.description      = <<-DESC
Swift version of UIView to show rate.This is based on an existing project.
                       DESC

  s.homepage         = 'https://github.com/zhouhao27/WOWRateView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Zhou Hao' => 'zhou.hao.27@gmail.com' }
  s.source           = { :git => 'https://github.com/zhouhao27/WOWRateView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'WOWRateView/Classes/**/*'
end
