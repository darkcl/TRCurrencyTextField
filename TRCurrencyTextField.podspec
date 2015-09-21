Pod::Spec.new do |s|
  s.name             = "TRCurrencyTextField"
  s.version          = "0.1.1"
  s.summary          = "iOS text field to input formatted currency value"
  s.description      = <<-DESC
                       The goal of the component is to make easy to input currency formatted text based on currency code, country code or locale.
                       DESC
  s.homepage         = "https://github.com/thiagoross/TRCurrencyTextField"
  s.license          = 'MIT'
  s.author           = { "Thiago Rossener" => "thiago@rossener.com" }
  s.source           = { :git => "https://github.com/thiagoross/TRCurrencyTextField.git", :tag => "v0.1.1" }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'TRCurrencyTextField' => ['Pod/Assets/*.png']
  }

  s.frameworks = 'UIKit', 'Foundation'
end
