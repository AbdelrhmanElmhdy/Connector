# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Connector' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Connector
  pod 'Socket.IO-Client-Swift', '~> 16.0.1'
  pod 'SwiftKeychainWrapper', '~> 4.0'
  pod 'ShimmerSwift'
  pod 'FirebaseCore', :git => 'https://github.com/firebase/firebase-ios-sdk.git', :branch => 'master'
  pod 'FirebaseFirestore'
  pod 'FirebaseAuth'
  pod 'Sourcery'
  
  target 'ConnectorTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Fakery'
  end

  target 'ConnectorUITests' do
    # Pods for testing
  end

end
