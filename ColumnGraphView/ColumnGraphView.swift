//
//  ColumnGraphView.swift
//  ColumnGraphView
//
//  Created by Apple on 1/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@IBDesignable

class ColumnGraphView: UIView {
    var percentages = [0.08, 0.6, 0.2, 0.9, 0.1, 0.3, 0.45, 0.55, 0.44]

    var column: Int {
        return percentages.count
    }

    var columnColors: [UIColor] {
        if column == 1 {
            return [Colors.mau_xanh * 0.5 + Colors.mau_do * 0.5]
        }
        let ratio = 1.0 / (column - 1).double
        var colors: [UIColor] = []
        for i in 0 ..< column {
            let color = Colors.mau_xanh * (1.0 - ratio * i.double) + Colors.mau_do * ratio * i.double
            colors.append(color)
        }
        return colors
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let contentHeight: CGFloat = 25.0
        let graphFrame = CGRect(x: rect.origin.x,
                                y: rect.origin.y,
                                width: rect.width,
                                height: rect.height - contentHeight)
        let contentFrame = CGRect(x: rect.origin.x,
                                  y: rect.height - graphFrame.height,
                                  width: rect.width,
                                  height: contentHeight)
        // Draw background
        let backgroundPath = UIBezierPath(rect: rect)
        UIColor.white.setFill()
        backgroundPath.fill()
        backgroundPath.close()
        // Draw separator line between graph area and content area
        let horizontalSeparatorLinePath = UIBezierPath()
        horizontalSeparatorLinePath.move(to: .init(x: rect.origin.x,
                                                   y: graphFrame.height))
        horizontalSeparatorLinePath.addLine(to: .init(x: rect.width,
                                                      y: graphFrame.height))
        UIColor.lightGray.setStroke()
        horizontalSeparatorLinePath.stroke()
        horizontalSeparatorLinePath.close()
        // Draw graph area
        drawGraph(in: graphFrame)
        // Draw content area
        drawContent(in: contentFrame)
    }

    // MARK: - Draw graph area

    private func drawGraph(in rect: CGRect) {
        // Draw separator line between column of graph
        drawVerticalSeparatorLine(in: rect)
        // Draw column data by percentage
        let columnWidth = rect.width / column.cgFloat
        for i in 0 ..< percentages.count {
            let columnFrame = CGRect(x: rect.origin.x + i.cgFloat * columnWidth,
                                     y: rect.origin.y,
                                     width: columnWidth,
                                     height: rect.height)
            drawColumnData(in: columnFrame, with: percentages[i].cgFloat, color: columnColors[i])
        }
    }

    private func drawVerticalSeparatorLine(in rect: CGRect) {
        let columnWidth = rect.width / column.cgFloat
        if column > 1 {
            // Draw vertical separator line
            let verticalSeparatorLinePath = UIBezierPath()
            for i in 0 ..< column - 1 {
                verticalSeparatorLinePath.move(to: .init(x: (i + 1).cgFloat * columnWidth,
                                                         y: 0.0))
                verticalSeparatorLinePath.addLine(to: .init(x: (i + 1).cgFloat * columnWidth,
                                                            y: rect.height))
            }
            UIColor.lightGray.setStroke()
            verticalSeparatorLinePath.stroke()
            verticalSeparatorLinePath.close()
            // Draw footer of separator line
            for i in 0 ..< column - 1 {
                let footerRadius: CGFloat = 3.0
                let footerFrame = CGRect(x: (i + 1).cgFloat * columnWidth - footerRadius,
                                         y: rect.height - footerRadius,
                                         width: footerRadius * 2,
                                         height: footerRadius * 2)
                let footerPath = UIBezierPath(ovalIn: footerFrame)
                UIColor.gray.setFill()
                footerPath.fill()
                footerPath.close()
            }
        }
    }

    private func drawColumnData(in rect: CGRect, with percentage: CGFloat, color: UIColor) {
        // Draw column data
        let columnDataFrame = CGRect(x: rect.origin.x + 0.25 * rect.width,
                                     y: rect.origin.y + (1.0 - percentage) * rect.height,
                                     width: 0.5 * rect.width,
                                     height: percentage * rect.height)
        let min = CGFloat.minimum(columnDataFrame.width / 2.0, columnDataFrame.height / 2.0)
        let columnDataPath = UIBezierPath(roundedRect: columnDataFrame,
                                          byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: min,
                                                                                                       height: min))
        color.setFill()
        columnDataPath.fill()
        columnDataPath.close()
        // Draw text percent
        let percent = percentage * 100
        let text = (String(format: "%g", percent) + "%") as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 17.0
        paragraphStyle.maximumLineHeight = 17.0
        paragraphStyle.alignment = .center
        let attributesText: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: paragraphStyle]
        let textFrame = CGRect(x: rect.origin.x,
                               y: columnDataFrame.origin.y - 20.0,
                               width: rect.width,
                               height: 20.0)
        text.draw(in: textFrame, withAttributes: attributesText)
    }

    // MARK: - Draw content area

    private func drawContent(in rect: CGRect) {
    }
}
