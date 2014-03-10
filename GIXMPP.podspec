Pod::Spec.new do |s|

  s.name         = "GIXMPP"
  s.version      = "0.0.1"
  s.summary      = "A short description of GIXMPP."
  
  s.description  = <<-DESC
                   A longer description of GIXMPP in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/appunite/GIXMPP.git"
  s.license      = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author             = { "piotrbernad" => "piotr.bernad@appunite.com" }
  s.platform     = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source       = { :git => "https://github.com/appunite/GIXMPP.git", :tag => "0.0.1" }
  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.dependency 'XMPPFramework', '~> 3.6.4'

end
