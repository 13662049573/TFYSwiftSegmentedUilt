Pod::Spec.new do |spec|

  spec.name         = "TFYSwiftSegmentedKit"

  spec.version      = "1.0.5"

  spec.summary      = "一个功能强大且高度可定制的iOS分段控制框架，具有丰富的特性。"

  spec.description  = <<-DESC
                     TFYSwiftSegmentedKit 是一个全面的iOS分段控制框架，提供以下功能：
                     功能特点：
                     * 多种指示器样式（线条、方块、背景等）
                     * 标题渐变效果和缩放动画
                     * 支持图文混合显示
                     * 自定义标题样式和富文本
                     * 动态数字显示和角标支持
                     * 圆点装饰和自定义布局
                     * RTL语言支持和自适应布局
                     * 列表容器联动与平滑动画
                     * 所有组件的丰富自定义选项
                     * 全面的示例项目和文档
                     * 高效的内存管理
                     * Swift 5.0+ 和 iOS 15.0+ 优化
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

  # 根据实际目录结构配置子规格
  spec.default_subspec = 'TFYSwiftBase'
  
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

  spec.framework    = "UIKit"

  spec.requires_arc = true

end
