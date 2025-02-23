//
//  IndicatorCustomizeViewController.swift
//  TFYSwiftView
//
//  Created by 田风有 on 2025/1/25.
//

import UIKit

class IndicatorCustomizeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 44
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var itemTitle: String?
        for subview in cell!.contentView.subviews {
            if let label = subview as? UILabel {
                itemTitle = label.text
                break
            }
        }

        let titles = ["猴哥", "青蛙王子", "旺财", "粉红猪", "喜羊羊", "黄焖鸡", "小马哥", "牛魔王", "大象先生", "神龙"]
        let vc = ContentBaseViewController()
        vc.title = itemTitle

        switch itemTitle! {
        case "LineView固定长度":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorLineView()
            indicator.indicatorWidth = 20
            vc.segmentedView.indicators = [indicator]
        case "LineView与Cell同宽":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorLineView()
            indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            vc.segmentedView.indicators = [indicator]
        case "LineView延长style":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorLineView()
            indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            indicator.lineStyle = .lengthen
            vc.segmentedView.indicators = [indicator]
        case "LineView延长+偏移style":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorLineView()
            indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            vc.segmentedView.indicators = [indicator]
        case "LineView彩虹":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorRainbowLineView()
            indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            indicator.lineStyle = .lengthenOffset
            indicator.indicatorColors = [.red, .green, .blue, .orange, .purple, .cyan, .gray, .red, .yellow, .blue]
            vc.segmentedView.indicators = [indicator]
        case "TriangleView三角形":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorTriangleView()
            vc.segmentedView.indicators = [indicator]
        case "BallView小红点":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView椭圆形":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView椭圆形+阴影":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.indicatorHeight = 30
            indicator.layer.shadowColor = UIColor.red.cgColor
            indicator.layer.shadowRadius = 3
            indicator.layer.shadowOffset = CGSize(width: 3, height: 4)
            indicator.layer.shadowOpacity = 0.6
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView遮罩有背景":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = false
            dataSource.isTitleMaskEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.isIndicatorConvertToItemFrameEnabled = true
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView遮罩无背景":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = false
            dataSource.isTitleMaskEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.alpha = 0
            indicator.isIndicatorConvertToItemFrameEnabled = true
            indicator.indicatorHeight = 30
            vc.segmentedView.indicators = [indicator]
        case "BackgroundView渐变色":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorBackgroundView()
            indicator.clipsToBounds = true
            indicator.indicatorHeight = 30
//            indicator.indicatorHeight = 3
//            indicator.indicatorPosition = .bottom
            //相当于把TFYSwiftIndicatorBackgroundView当做视图容器，你可以在上面添加任何想要的效果
            //这里的方案主要提供一个可以在指示器视图添加自己视图的思路，如果只是需要渐变色lineView。请参考下面的【GradientLine渐变色】示例，使用TFYSwiftIndicatorGradientLineView类即可。
            let gradientView = TFYSwiftComponetGradientView()
            gradientView.gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientView.gradientLayer.colors = [UIColor(red: 90/255, green: 215/255, blue: 202/255, alpha: 1).cgColor, UIColor(red: 122/255, green: 232/255, blue: 169/255, alpha: 1).cgColor]
            //设置gradientView布局和TFYSwiftIndicatorBackgroundView一样
            gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            indicator.addSubview(gradientView)
            vc.segmentedView.indicators = [indicator]
        case "GradientLine渐变色":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorGradientLineView()
            indicator.colors = [UIColor.red, UIColor.green]
            vc.segmentedView.indicators = [indicator]
        case "ImageView底部":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorImageView()
            indicator.image = UIImage(named: "car")
            indicator.indicatorWidth = 24
            indicator.indicatorHeight = 18
            vc.segmentedView.indicators = [indicator]
        case "ImageView背景":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorImageView()
            indicator.indicatorWidth = 50
            indicator.indicatorHeight = 50
            indicator.image = UIImage(named: "light")
            vc.segmentedView.indicators = [indicator]
        case "混合使用":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let lineIndicator = TFYSwiftIndicatorLineView()
            lineIndicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            lineIndicator.lineStyle = .normal

            let bgIndicator = TFYSwiftIndicatorBackgroundView()
            bgIndicator.indicatorHeight = 30
            vc.segmentedView.indicators = [lineIndicator, bgIndicator]
        case "DotLine点线效果":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorDotLineView()
            vc.segmentedView.indicators = [indicator]
        case "DoubleLine双线效果":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorDoubleLineView()
            vc.segmentedView.indicators = [indicator]
        case "GradientView渐变色":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = titles
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorGradientView()
//            indicator.indicatorHeight = 3
//            indicator.indicatorPosition = .bottom

            vc.segmentedView.indicators = [indicator]
        case "指示器宽度跟随内容而不是cell宽度":
            //配置数据源
            let dataSource = TFYSwiftTitleDataSource()
            dataSource.isTitleColorGradientEnabled = true
            dataSource.titles = ["很长的第一名", "第二", "普通第三"]
            dataSource.itemWidth = view.bounds.size.width/3
            dataSource.itemSpacing = 0
            dataSource.isTitleZoomEnabled = true
            vc.segmentedDataSource = dataSource
            //配置指示器
            let indicator = TFYSwiftIndicatorLineView()
            indicator.indicatorWidth = TFYSwiftViewAutomaticDimension
            indicator.isIndicatorWidthSameAsItemContent = true
            vc.segmentedView.indicators = [indicator]
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
