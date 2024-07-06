# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TOG' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TOG

  target 'TOGTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TOGUITests' do
    # Pods for testing
  end

pod 'RxSwift'
pod 'RxCocoa'
pod 'RxGesture'
pod 'NSObject+Rx'
pod 'SnapKit'
pod 'Then' 
pod 'SDWebImage'
pod 'Alamofire' 
pod 'JGProgressHUD'
pod 'SideMenu'
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'
pod 'Firebase/Messaging'
pod 'Firebase/Auth'
pod 'GoogleSignIn'
pod "MarkdownKit"
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0' # 원하는 최소 버전
      end
    installer.pods_project.build_configurations.each do |config|
        config.build_settings['CLANG_ANALYZER_LOCALIZABILITY_NONLOCALIZED'] = 'YES'
        config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
      end
    end
end

