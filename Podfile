# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'IrishRailAPI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Swinject'
  pod 'SwinjectStoryboard'
  pod 'SwiftLint'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxSwiftExt'
  pod 'Moya/RxSwift'

  # Pods for IrishRailAPI

  target 'IrishRailAPITests' do
    inherit! :complete
    # Pods for testing
  end

  target 'IrishRailAPIUITests' do
    # Pods for testing
  end

  post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
        end
      end
  end

end
