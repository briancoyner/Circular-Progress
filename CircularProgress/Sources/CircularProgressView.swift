//
//  Created by Brian Coyner on 9/3/18.
//  Copyright © 2018 Brian Coyner. All rights reserved.
//


import Foundation
import UIKit

/// A customizable progress view that displays progress using circular paths/ rings.
/// The progress view is customized using a `CircularProgressViewStrategy`.
///
/// There are a few predefined strategies:
/// - `BasicCircularProgressViewStrategy`
/// - `InsetCircularProgressViewStrategy`
/// - `FilledCircularProgressViewStrategy`

public final class CircularProgressView: UIView {

    /// This method changes the view's state with animation.
    ///
    /// The view can be in two states:
    /// # `.indeterminate`
    /// # `.progress(CGFloat)`
    ///
    /// A state change is necessary to change the view's progress.
    ///
    /// - SeeAlso: `setState(_:animated:)`
    public var state: State {
        set {
            transition(from: state, to: newValue, animated: true)
        }
        get {
            return _state
        }
    }

    fileprivate var _state: State = .progress(0.0)

    // The strategy is passed to the initializer, and is used to control
    // how the circular layers are presented and animated.
    fileprivate let strategy: CircularProgressViewStrategy

    // This state (see bottom of file) manages the `CADisplayLink` and active
    // `CAAnimation`s used to animate the progress layer.
    fileprivate var internalState: AnimationState = .idle

    // The radius is calculated and cached when the `layoutSubviews` executes.
    // The radius is read during the `CADisplayLink` callbacks.
    fileprivate var radius: CGFloat = 0
    fileprivate var layerCenter = CGPoint()

    fileprivate lazy var backgroundLayer = self.lazyBackgroundLayer()
    fileprivate lazy var progressLayer = self.lazyProgressLayer()
    fileprivate lazy var additionalContentLayer = self.lazyAdditionalContentLayer()

    fileprivate lazy var progressLayerDelegate = self.lazyProgressLayerDelegate()
    fileprivate lazy var strategyLayers = self.lazyStrategyLayers()

    /// Creates a new progress view with the custom strategy.
    ///
    /// - Parameter strategy: the strategy used to render the bulk of the progress view.
    public init(strategy: CircularProgressViewStrategy) {
        self.strategy = strategy

        super.init(frame: CGRect())
        selfInit()
    }

    /// Creates a new progress view that uses a `FormattedStringCircularProgressViewStrategy`.
    ///
    /// - Parameter frame: the frame rectangle for the view.
    public override init(frame: CGRect) {
        self.strategy = BasicCircularProgressViewStrategy()

        super.init(frame: frame)
        selfInit()
    }

    /// Creates a new progress view from an unarchiver object that uses a `FormattedStringCircularProgressViewStrategy`.
    ///
    /// - Parameter coder: an unarchiver object.
    public required init?(coder aDecoder: NSCoder) {
        self.strategy = BasicCircularProgressViewStrategy()

        super.init(coder: aDecoder)
        selfInit()
    }

    fileprivate func selfInit() {
        translatesAutoresizingMaskIntoConstraints = false

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
        layer.addSublayer(additionalContentLayer)

        strategy.updateTintColor(tintColor, on: strategyLayers, state: state)
    }

    deinit {
        if case .animating(let displayLink, _) = internalState {
            displayLink.invalidate()
            internalState = .idle
        }

        progressLayer.delegate = nil
    }
}

extension CircularProgressView {

    /// See the comments on the `state` property.
    ///
    /// - Parameters:
    ///   - state: the new state of the view.
    ///   - animated: `true` if the view animates to the new state.
    public func setState(_ state: State, animated: Bool) {
        transition(from: _state, to: state, animated: animated)
    }
}

extension CircularProgressView {

    override public func layoutSubviews() {
        super.layoutSubviews()

        // The view's bounds may not be a square. Therefore, the radius
        // is based on the shortest side.
        //
        // A new center is calculated based on the bounds, not the frame
        // to allow the strategy to layout custom layers and create and
        // apply custom `CGPath`s.
        radius = min(bounds.width, bounds.height) * 0.5
        layerCenter = CGPoint(x: bounds.midX, y: bounds.midY)

        layoutSublayers([backgroundLayer, additionalContentLayer, progressLayer], bounds: bounds, position: layerCenter)
        strategy.layoutLayers(strategyLayers, center: layerCenter, radius: radius)

        // The progress layer needs to be adjusted when the layout changes.
        // Note: The progress layer may be in the middle of animating.
        update(progressLayer, endAngle: progressLayer.angle)
    }
}

extension CircularProgressView {

    override public func tintColorDidChange() {
        strategy.updateTintColor(tintColor, on: strategyLayers, state: state)
    }
}

extension CircularProgressView: CAAnimationDelegate {

    //
    // The animation delegate is notified when the `ProgressLayer`'s `angle` changes.
    // The angle changes when the progress value.
    //

    public func animationDidStart(_ animation: CAAnimation) {
        guard case .progress(_) = state else {
            return
        }

        switch internalState {
        case .idle:
            let displayLink = CADisplayLink(target: self, selector: #selector(updateTimerFired(_:)))
            displayLink.add(to: .main, forMode: .common)
            internalState = .animating(displayLink: displayLink, animations: Set(arrayLiteral: animation))
        case .animating(let displayLink, let animations):
            var newAnimations = animations
            newAnimations.insert(animation)
            internalState = .animating(displayLink: displayLink, animations: newAnimations)
        }
    }

    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        switch internalState {
        case .idle:
            // The internal state should not be idle when there are still animations.
            break
        case .animating(let displayLink, let animations):
            var updatedAnimations = animations
            updatedAnimations.remove(animation)

            if updatedAnimations.count == 0 {
                update(progressLayer, endAngle: progressLayer.angle)
                displayLink.invalidate()
                internalState = .idle
            } else {
                internalState = .animating(displayLink: displayLink, animations: updatedAnimations)
            }
        }
    }
}

extension CircularProgressView {

    fileprivate func transition(from _: State, to newState: State, animated: Bool) {
        _state = newState

        if animated {
            CATransaction.begin()
            updatedProgress(to: newState, animated: animated)
            CATransaction.commit()
        } else {
            CATransaction.setDisableActions(true)
            updatedProgress(to: newState, animated: animated)
        }
    }
    
    fileprivate func updatedProgress(to newState: State, animated: Bool) {
        strategy.transitionLayers(strategyLayers, to: newState, tintColor: tintColor)
        
        if case .progress(let progress) = newState {
            setProgress(progress, animated: animated)
        }
    }

    fileprivate func setProgress(_ progress: FractionCompleted, animated: Bool) {
        if animated {
            // When animating we can simply set the `progress` on the layer. The
            // `ProgressLayerDelegate` takes care of the rest.
            progressLayer.progress = progress
        } else {
            // We need to update the layer's progress even though we are not animating.
            // This ensures that the next progress animation event starts at the correct angle.
            // We need to disable the layer animation before setting the angle. Otherwise
            // the layer animates. We disable the animation by simply setting the layer's
            // delegate to nil.
            progressLayer.delegate = nil
            progressLayer.progress = progress
            update(progressLayer, endAngle: progressLayer.angle)
            progressLayer.delegate = progressLayerDelegate
        }
    }
}

extension CircularProgressView {

    @objc
    fileprivate func updateTimerFired(_ displayLink: CADisplayLink) {
        guard let endAngle = progressLayer.presentation()?.angle else {
            return
        }
        update(progressLayer, endAngle: endAngle)
    }

    fileprivate func update(_ progressLayer: ProgressLayer, endAngle: CGFloat) {
        CATransaction.setDisableActions(true)
        progressLayer.path = strategy.progressPath(for: layerCenter, radius: radius, angle: endAngle)
        CATransaction.setDisableActions(false)
    }
}

extension CircularProgressView {

    fileprivate func layoutSublayers(_ layers: [CALayer], bounds: CGRect, position: CGPoint) {
        for currentLayer in layers {
            currentLayer.bounds = bounds
            currentLayer.position = layerCenter
        }
    }
}

extension CircularProgressView {

    fileprivate func lazyBackgroundLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.setAffineTransform(defaultLayerTransform)

        return layer
    }

    fileprivate func lazyAdditionalContentLayer() -> CALayer {
        let layer = CALayer()
        layer.contentsScale = UIScreen.main.scale
        return layer
    }

    fileprivate func lazyProgressLayer() -> ProgressLayer {
        let layer = ProgressLayer()
        layer.contentsScale = UIScreen.main.scale
        layer.setAffineTransform(defaultLayerTransform)
        layer.delegate = progressLayerDelegate

        return layer
    }

    fileprivate func lazyStrategyLayers() -> Layers {
        return Layers(
            backgroundLayer: backgroundLayer,
            progressLayer: progressLayer,
            additionalContentLayer: additionalContentLayer
        )
    }

    fileprivate func lazyProgressLayerDelegate() -> ProgressLayerDelegate {
        return ProgressLayerDelegate(delegate: self)
    }

    fileprivate var defaultLayerTransform: CGAffineTransform {
        // A -90 degree rotation transform applied to some of the layers to
        // help simply the math needed draw paths that start at "12 o'clock".
        return CGAffineTransform(rotationAngle: -(.pi / 2))
    }
}

extension CircularProgressView {

    /// A private implementation state used to help track the state of the
    /// animating `ProgressLayer`.
    fileprivate enum AnimationState {
        case idle
        case animating(displayLink: CADisplayLink, animations: Set<CAAnimation>)
    }
}
