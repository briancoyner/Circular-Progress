//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//

import Foundation
import UIKit

/// An "additional" content layout strategy that displays progress as localized text in the center
/// of the progress view.
///
/// Developers may override the text color if the view's tint color is not desired.

public final class LocalizedProgressAdditionalContentLayoutStrategy: CircularProgressViewAdditionalContentLayoutStrategy {

    fileprivate let textColor: UIColor?

    fileprivate lazy var textLayer = self.lazyTextLayer()
    fileprivate lazy var progressFormatter = self.lazyProgressFormatter()

    public init(textColor: UIColor? = nil) {
        self.textColor = textColor
    }
}

extension LocalizedProgressAdditionalContentLayoutStrategy {

    public func layoutAdditionalContent(in layer: CALayer, center: CGPoint, radius: CGFloat) {
        if textLayer.superlayer == nil {
            layer.addSublayer(textLayer)
        }

        layout(textLayer, center: center, maxWidth: radius * 1.3)
    }
}

extension LocalizedProgressAdditionalContentLayoutStrategy {

    public func transitionAdditionalContent(to state: CircularProgressView.State, tintColor: UIColor) {
        guard case .progress(let percentComplete) = state else {
            return
        }

        updateTintColor(tintColor, state: state)
        textLayer.string = progressFormatter.string(from: NSNumber(value: percentComplete.rawValue))
    }
}

extension LocalizedProgressAdditionalContentLayoutStrategy {

    public func updateTintColor(_ tintColor: UIColor, state: CircularProgressView.State) {
        textLayer.foregroundColor = textColor?.cgColor ?? tintColor.cgColor
    }
}

extension LocalizedProgressAdditionalContentLayoutStrategy {

    fileprivate func layout(_ textLayer: CATextLayer, center: CGPoint, maxWidth: CGFloat) {
        let prototypeString: NSString = NSString(string: progressFormatter.string(from: NSNumber(value: 100)) ?? "100%")
        let textLayerFont = textLayer.font as! UIFont
        let fontSize = calculateFontSize(for: textLayerFont, maxWidth: maxWidth, prototypeString: prototypeString)

        let newFont = textLayerFont.withSize(fontSize)
        let size = prototypeString.size(withAttributes: [.font: newFont])

        textLayer.bounds = CGRect(origin: CGPoint(), size: size)
        textLayer.position = center
        textLayer.fontSize = fontSize
        textLayer.isHidden = fontSize < 13.0
    }

    private func calculateFontSize(for font: UIFont, maxWidth: CGFloat, prototypeString: NSString) -> CGFloat {
        let fontSize: CGFloat = 120.0

        var currentFont = font.withSize(fontSize)
        var currentSize = prototypeString.size(withAttributes: [.font: currentFont])
        while currentSize.width > maxWidth {
            let newFontSize = currentFont.pointSize - 1.0
            currentFont = currentFont.withSize(newFontSize)
            currentSize = prototypeString.size(withAttributes: [.font: currentFont])
        }

        return currentFont.pointSize
    }
}

extension LocalizedProgressAdditionalContentLayoutStrategy {

    fileprivate func lazyTextLayer() -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = .center

        return textLayer
    }

    fileprivate func lazyProgressFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter
    }
}
