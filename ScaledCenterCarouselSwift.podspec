Pod::Spec.new do |spec|

  spec.name                   = "ScaledCenterCarouselSwift"
  spec.version                = "1.0.0"
  spec.summary                = "A carousel-based layout for UICollectionView with scaled center item."
  spec.description            = <<-DESC
A carousel-based layout for UICollectionView with scaled center item. 
It also contains paginator to force user to select single item which will be presented exaclty at center of carousel.
                              DESC
  spec.homepage               = 'https://github.com/yuriy-tolstoguzov/ScaledCenterCarousel'
  spec.screenshots            = 'https://raw.githubusercontent.com/yuriy-tolstoguzov/ScaledCenterCarousel/master/Example/Assets/ScaledCenterCarousel.gif'
  spec.license                = { :type => "MIT", :file => "LICENSE" }

  spec.author                 = { 'yuriy-tolstoguzov' => 'Yuriy.Tolstoguzov@gmail.com' }
  spec.social_media_url       = 'https://twitter.com/ImOssir'

  spec.ios.deployment_target  = "8.0"
  spec.swift_version          = "5.0"
  spec.source                 = { :git => 'https://github.com/yuriy-tolstoguzov/ScaledCenterCarousel.git', :tag => "#{spec.version}-Swift" }
  spec.source_files           = 'Swift/ScaledCenterCarousel/Classes/**/*'
  spec.frameworks             = 'UIKit'

end
