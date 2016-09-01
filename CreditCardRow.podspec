Pod::Spec.new do |s|
  s.name             = "CreditCardRow"
  s.version          = "1.0.0"
  s.summary          = "An Eureka row that allows the user to input a credit card number with optional CVC and expiration date."
  s.homepage         = "https://github.com/xmartlabs/CreditCardRow"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Xmartlabs SRL" => "swift@xmartlabs.com" }
  s.source           = { git: "https://github.com/xmartlabs/CreditCardRow.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmartlabs'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.ios.source_files = 'Sources/**/*.swift'
  s.resource_bundles = {
      'CreditCardRow' => [
          'Sources/**/*.xib'
      ]
    }
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.dependency 'Eureka', '~> 1.0'
end
