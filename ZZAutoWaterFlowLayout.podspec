#
# Be sure to run `pod lib lint ZZAutoWaterFlowLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZZAutoWaterFlowLayout'
  s.version          = '0.0.3'
  s.summary          = '自适应高度瀑布流Layout，需要在UICollectionViewCell中约束Cell的宽度。'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MartinChristopher/ZZAutoWaterFlowLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'MartinChristopher' => '519483040@qq.com' }
  s.source           = { :git => 'https://github.com/MartinChristopher/ZZAutoWaterFlowLayout.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.platform              = :ios, "9.0"
  s.swift_version         = '5.0'

  s.source_files = 'ZZAutoWaterFlowLayout/**/*.{swift}'
  
  # s.resource_bundles = {
  #   'ZZAutoWaterFlowLayout' => ['ZZAutoWaterFlowLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
