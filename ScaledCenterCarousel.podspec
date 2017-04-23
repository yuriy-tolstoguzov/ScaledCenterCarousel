#
# Be sure to run `pod lib lint ScaledCenterCarousel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ScaledCenterCarousel'
  s.version          = '1.0.0'
  s.summary          = 'A carousel-based layout for UICollectionView with scaled center item.'
  s.description      = <<-DESC
A carousel-based layout for UICollectionView with scaled center item. 
It also contains paginator to force user to select single item which will be presented exaclty at center of carousel.
                       DESC

  s.homepage         = 'https://github.com/yuriy-tolstoguzov/ScaledCenterCarousel'
  s.screenshots      = 'https://raw.githubusercontent.com/yuriy-tolstoguzov/ScaledCenterCarousel/master/Example/Assets/ScaledCenterCarousel.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yuriy-tolstoguzov' => 'Yuriy.Tolstoguzov@gmail.com' }
  s.source           = { :git => 'https://github.com/yuriy-tolstoguzov/ScaledCenterCarousel.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ImOssir'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ScaledCenterCarousel/Classes/**/*'
  

  s.public_header_files = 'ScaledCenterCarousel/Classes/*.h'
  s.frameworks = 'UIKit'
end
