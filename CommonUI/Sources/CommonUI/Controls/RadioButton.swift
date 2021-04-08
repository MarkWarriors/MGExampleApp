//
//  RadioButton.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit
import CommonComponents

public final class RadioButton: UIControl {

  private let onColour = UIColor.red
  private let offColour = UIColor.gray

  private let outerLineWidth: CGFloat = 1
  private let innerCirclePadding: CGFloat = 5

  private var halfOuterLineWidth: CGFloat {
    return outerLineWidth / 2.0
  }

  private var outerCircleRect: CGRect {
    return bounds.insetBy(dx: halfOuterLineWidth, dy: halfOuterLineWidth)
  }

  private var innerCircleRect: CGRect {
    return outerCircleRect.insetBy(dx: padding, dy: padding)
  }

  private var padding: CGFloat {
    return innerCirclePadding - halfOuterLineWidth
  }

  private lazy var outerShapeLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineWidth = outerLineWidth
    return shapeLayer
  }()

  private lazy var innerShapeLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    return shapeLayer
  }()

  private let timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.3, 0.8, 1)
  private let zeroScale = CATransform3DMakeScale(0.0, 0.0, 1)

  public override var isSelected: Bool {
    didSet {
      guard oldValue != isSelected else { return }

      if isSelected {
        animateToSelected()
      } else {
        animateToUnselected()
      }
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    commonInit()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    commonInit()
  }

  private func commonInit() {
    addTarget(self, action: #selector(generateHaptic), for: .touchUpInside)

    setupOuterLayerPath()
    setupInnerLayerPath()

    layer.addSublayer(outerShapeLayer)
    layer.addSublayer(innerShapeLayer)

    updateColors(isSelected)
  }

  private func setupOuterLayerPath() {
    let outerCircle = UIBezierPath(ovalIn: outerCircleRect)
    outerShapeLayer.path = outerCircle.cgPath
  }

  private func setupInnerLayerPath() {
    let innerCircle = UIBezierPath(ovalIn: innerCircleRect)
    innerShapeLayer.path = innerCircle.cgPath
    innerShapeLayer.frame = bounds
  }

  private func createSelectedAnimation() -> CABasicAnimation {
    let selectedAnimation = CABasicAnimation(keyPath: "transform")
    selectedAnimation.duration = 0.15
    selectedAnimation.fromValue = zeroScale
    selectedAnimation.toValue = CATransform3DIdentity
    selectedAnimation.timingFunction = timingFunction
    selectedAnimation.isRemovedOnCompletion = true

    return selectedAnimation
  }

  private func createUnselectedAnimation() -> CABasicAnimation {
    let unselectedAnimation = CABasicAnimation(keyPath: "transform")
    unselectedAnimation.duration = 0.15
    unselectedAnimation.fromValue = CATransform3DIdentity
    unselectedAnimation.toValue = zeroScale
    unselectedAnimation.timingFunction = timingFunction
    unselectedAnimation.isRemovedOnCompletion = true

    return unselectedAnimation
  }

  private func animateToSelected() {
    updateColors(isSelected)

    let animation = createSelectedAnimation()
    innerShapeLayer.add(animation, forKey: "transform")
    innerShapeLayer.transform = CATransform3DIdentity

    innerShapeLayer.setNeedsDisplay()
    outerShapeLayer.setNeedsDisplay()
  }

  private func animateToUnselected() {
    updateColors(isSelected)

    let animation = createUnselectedAnimation()

    innerShapeLayer.add(animation, forKey: "transform")
    innerShapeLayer.transform = zeroScale

    innerShapeLayer.setNeedsDisplay()
    outerShapeLayer.setNeedsDisplay()
  }

  private func updateColors(_ isSelected: Bool) {
    let strokeColorOuter: UIColor = isSelected ? onColour : offColour
    let strokeColorInner: UIColor = isSelected ? onColour : .white

    let fillColorOuter: UIColor = .white
    let fillColorInner = isSelected ? onColour : .white

    outerShapeLayer.strokeColor = strokeColorOuter.cgColor
    outerShapeLayer.fillColor = fillColorOuter.cgColor

    innerShapeLayer.strokeColor = strokeColorInner.cgColor
    innerShapeLayer.fillColor = fillColorInner.cgColor
  }

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let desiredSize = CGSize(width: 44, height: 44)

    let dx = max(desiredSize.width - bounds.width, 0)
    let dy = max(desiredSize.height - bounds.height, 0)
    let hitTestFrame = bounds.insetBy(dx: -dx/2, dy: -dy/2)

    return hitTestFrame.contains(point) ? self : nil
  }

  @objc private func generateHaptic() {
    Haptic.selection.generate(prepareForReuse: true)
  }
}
