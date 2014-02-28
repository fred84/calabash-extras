Gem::Specification.new do |spec|
  spec.name          = 'calabash-extras'
  spec.version       = '0.0.1'
  spec.authors       = ['Sergey Galkin']
  spec.email         = ['sergey@galkin.me']
  spec.description   = %q{TestCase and page traversal tool for writing xunit tests for Android and Ios apps}
  spec.summary       = %q{Utils for writing xunit tests with calabash and page objects}

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'calabash-android'
  spec.add_dependency 'calabash-cucumber'
  spec.add_dependency 'PriorityQueue'
end
