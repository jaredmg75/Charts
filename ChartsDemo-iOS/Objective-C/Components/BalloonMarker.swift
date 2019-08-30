//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts


open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 15, height: 11)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x += padding
        origin.y -= height / 2

        if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width //Too far right
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0 //Too high
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height  //Too low
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
//        rect.origin.x += size.width
        rect.origin.y -= size.height / 2.0
        
        context.saveGState()

        context.setStrokeColor(color.cgColor)
        context.setFillColor(UIColor.black.cgColor)

//        if offset.y > 0
//        {
            context.beginPath()
            context.move(to: CGPoint(
                x: rect.origin.x + arrowSize.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width,
                y: rect.origin.y + (rect.size.height / 2.0) - (arrowSize.height / 2)))
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width,
                y: rect.origin.y + (rect.size.height / 2.0) + (arrowSize.height / 2)))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width + rect.size.width,
                y: rect.origin.y + rect.size.height))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width + rect.size.width,
                y: rect.origin.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + arrowSize.width,
                y: rect.origin.y))

            context.drawPath(using: CGPathDrawingMode.fillStroke)
        

//        }
//        else
//        {
//            context.beginPath()
//            context.move(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + rect.size.width,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            //arrow vertex
//            context.addLine(to: CGPoint(
//                x: point.x,
//                y: point.y))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y + rect.size.height - arrowSize.height))
//            context.addLine(to: CGPoint(
//                x: rect.origin.x,
//                y: rect.origin.y))
////            context.fillPath()
//            context.drawPath(using: CGPathDrawingMode.stroke)
//        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        rect.origin.x += self.arrowSize.width + self.insets.left
        rect.size.height -= self.insets.top + self.insets.bottom
        rect.size.width -= self.insets.left + self.insets.right

        UIGraphicsPushContext(context)
        
        label.draw(in: rect, withAttributes: _drawAttributes)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(String(entry.y))
    }
    
    @objc open func setLabel(_ newLabel: String)
    {
        label = newLabel
        
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
