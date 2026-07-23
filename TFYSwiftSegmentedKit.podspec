Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftSegmentedKit"

  spec.version      = "2.0.1"

  spec.summary      = "一个功能强大且高度可定制的iOS分段控制框架，具有丰富的特性。"

  spec.description  = <<-DESC
                     TFYSwiftSegmentedKit 2.0 — 纯 Swift、与 JXSegmentedView 解耦的
                     分段控件 / 分页标签组件库。
                     功能特点：
                     * 12+ 指示器样式（Line/DoubleLine/Dot/Triangle/Rainbow/Background/
                       Gradient/GradientLine/Image/Capsule/ElasticLine/Blur/Symbol）
                     * 标题渐变、图文混合、富文本、动态数字、角标、圆点
                     * 拖拽重排、Context Menu、Long Press 钩子、触感反馈
                     * 可访问性：自动订阅 Reduce Motion、accessibilityValue/hint、
                       WCAG 对比度校验
                     * UICollectionViewDiffableDataSource 开关 / os_signpost 诊断
                     * Combine Publishers + async selectItem(at:animated:)
                     * SwiftUI：TFYSwiftSegmentedView 与 TFYSwiftPagingContainer
                     * GitHub Actions CI（build / test-spm / lint / pod-lint）
                     * Swift 5.9 / 6.0 · iOS 15+
                     DESC

  spec.homepage     = "https://github.com/13662049573/TFYSwiftSegmentedUilt"
 

  spec.license      = { :type => "MIT", :file => "LICENSE" }
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "15.0"
  
  spec.swift_version = "5.0"

  spec.source       = { 
    :git => "https://github.com/13662049573/TFYSwiftSegmentedUilt.git", 
    :tag => spec.version
  }

  # 默认集成全部子模块（使用 default_subspecs 的复数形式以支持多个默认子规格）
  spec.default_subspecs = 'TFYSwiftTool',
                          'TFYSwiftBase',
                          'TFYSwiftTitle',
                          'TFYSwiftAttributeTitle',
                          'TFYSwiftDot',
                          'TFYSwiftIndicator',
                          'TFYSwiftNumber',
                          'TFYSwiftTitleGradient',
                          'TFYSwiftTitleImage',
                          'TFYSwiftTitleOrImage',
                          'TFYSwiftPagingView',
                          'TFYSwiftSwiftUI'
  
  # Tool 模块（其他模块都依赖它）
  spec.subspec 'TFYSwiftTool' do |tool|
    tool.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftTool/**/*.swift'
  end
  
  # Base 模块（依赖 Tool）
  spec.subspec 'TFYSwiftBase' do |base|
    base.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftBase/**/*.swift'
    base.dependency 'TFYSwiftSegmentedKit/TFYSwiftTool'
  end
  
  # Title 模块（其他模块都依赖它）
  spec.subspec 'TFYSwiftTitle' do |title|
    title.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftTitle/**/*.swift'
    title.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
  end
  
  spec.subspec 'TFYSwiftAttributeTitle' do |attributeTitle|
    attributeTitle.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftAttributeTitle/**/*.swift'
    attributeTitle.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    attributeTitle.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
  end
  
  spec.subspec 'TFYSwiftDot' do |dot|
    dot.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftDot/**/*.swift'
    dot.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    dot.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
  end
  
  spec.subspec 'TFYSwiftIndicator' do |indicator|
    indicator.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftIndicator/**/*.swift'
    indicator.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    indicator.dependency 'TFYSwiftSegmentedKit/TFYSwiftTool'
  end
  
  spec.subspec 'TFYSwiftNumber' do |number|
    number.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftNumber/**/*.swift'
    number.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    number.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
  end
  
  spec.subspec 'TFYSwiftTitleGradient' do |titleGradient|
    titleGradient.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftTitleGradient/**/*.swift'
    titleGradient.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    titleGradient.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
  end
  
  spec.subspec 'TFYSwiftTitleImage' do |titleImage|
    titleImage.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftTitleImage/**/*.swift'
    titleImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    titleImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
    titleImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftTool'
  end
  
  spec.subspec 'TFYSwiftTitleOrImage' do |titleOrImage|
    titleOrImage.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftTitleOrImage/**/*.swift'
    titleOrImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    titleOrImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
    titleOrImage.dependency 'TFYSwiftSegmentedKit/TFYSwiftTool'
  end

  # PagingView 依赖 Base / Tool / Title（内部使用 segmentedView 的列表容器协议与工具类）
  spec.subspec 'TFYSwiftPagingView' do |paging|
    paging.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftPagingView/**/*.swift'
    paging.dependency 'TFYSwiftSegmentedKit/TFYSwiftTool'
    paging.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    paging.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
  end

  # SwiftUI 封装层：TFYSwiftSegmentedView + TFYSwiftPagingContainer
  spec.subspec 'TFYSwiftSwiftUI' do |swui|
    swui.source_files = 'TFYSwiftSegmentedUilt/TFYSwiftSegmentedKit/TFYSwiftSwiftUI/**/*.swift'
    swui.dependency 'TFYSwiftSegmentedKit/TFYSwiftBase'
    swui.dependency 'TFYSwiftSegmentedKit/TFYSwiftTitle'
    swui.dependency 'TFYSwiftSegmentedKit/TFYSwiftIndicator'
    swui.weak_frameworks = 'SwiftUI', 'Combine'
  end

  spec.framework    = "UIKit"

  spec.requires_arc = true

end
