# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'crypto-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for crypto-ios
  pod 'Alamofire', '4.8.2'
  pod 'SDWebImage'
  pod 'SDWebImageSVGKitPlugin'
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'

  target 'crypto-iosTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'iOSSnapshotTestCase'
  end

  target 'crypto-iosUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "15.0"
    end
  end
end
