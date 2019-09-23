platform :ios, '12.0'

def shared_pods
  pod 'Alamofire'
  pod 'Charts'
  pod 'Disk'
  pod 'lottie-ios'
  pod 'SwiftyJSON'
  pod 'Alamofire-SwiftyJSON'
  pod 'GoogleMaps'
  pod 'Google-Maps-iOS-Utils'
  pod 'p2.OAuth2'
  pod 'OAuth2'
end

target 'Swonzo' do
  shared_pods
end

target 'SwonzoTests' do
  inherit! :search_paths
  shared_pods
end

target 'SwonzoUITests' do
  inherit! :search_paths
  shared_pods
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
  end
end
