Pod::Spec.new do |s|
  s.name             = 'AssertionNotifier'
  s.version          = '0.1.0'
  s.summary          = 'Sends a notification with extra info after an assertion fails.'

  s.description      = 'Get a notification with extra info about  crash like the file and line after as assertion fails to help you debugging'

  s.homepage         = 'https://github.com/elisioff/AssertionNotifier'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Elísio Fernandes'
  s.source           = { :git => 'https://github.com/elisioff/AssertionNotifier.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/elisioff'

  s.swift_version = '5.0'
  s.ios.deployment_target = '13'
  #s.osx.deployment_target  = '10.14'

  s.source_files = 'AssertionNotifier/Classes/**/*'

  # s.resource_bundles = {
  #   'AssertionNotifier' => ['AssertionNotifier/Assets/*.png']
  # }
end
