# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'


target 'Swap' do
# Comment the next line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

# Pods for Swap

pod 'p2.OAuth2’, ‘3.0.2’
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Kingfisher’, :git => 'https://github.com/onevcat/Kingfisher.git’, :branch => 'swift3'
pod 'IQKeyboardManagerSwift'
pod 'Branch'
pod 'OneSignal’
pod 'Fabric'
pod 'Answers'
pod 'TwitterKit'
pod 'Crashlytics'
pod 'CountryPickerSwift'
pod 'PhoneNumberKit’, :git => ’https://github.com/marmelroy/PhoneNumberKit.git', :branch => ‘swift3’
#pod 'FacebookCore'
#pod 'FacebookLogin'
pod 'Spring’, :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
pod 'Swifter', :git => 'https://github.com/mattdonnelly/Swifter.git'
post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
xcconfig_path = config.base_configuration_reference.real_path
xcconfig = File.read(xcconfig_path)
new_xcconfig = xcconfig.sub('OTHER_LDFLAGS = $(inherited) -ObjC', 'OTHER_LDFLAGS = $(inherited)')
File.open(xcconfig_path, "w") { |file| file << new_xcconfig }
end
end
end
end
