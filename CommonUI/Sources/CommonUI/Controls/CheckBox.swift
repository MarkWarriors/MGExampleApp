//
//  CheckBox.swift
//  
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit
import CommonComponents

public final class ShellCheckBox: UIControl {

  private lazy var backgroundLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.gray.cgColor
    shapeLayer.fillColor = unselectedBackgroundColor.cgColor
    return shapeLayer
  }()

  private lazy var tickLayer: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.fillColor = nil
    shapeLayer.lineWidth = 2.8

    return shapeLayer
  }()

  private let unselectedBackgroundColor: UIColor = .white
  private let selectedBackgroundColor: UIColor = UIColor.green

  private let timingFunction: CAMediaTimingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.3, 0.8, 1)

  public override var isSelected: Bool {
    didSet {
      guard oldValue != isSelected else { return }

      if isSelected {
        animateToChecked()
      } else {
        animateToUnchecked()
      }
    }
  }

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: 22, height: 22)
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
    layer.addSublayer(backgroundLayer)
    layer.addSublayer(tickLayer)
    addTarget(self, action: #selector(generateHaptic), for: .touchUpInside)
  }

  public override func layoutSubviews() {
    setupBackgroundPath()
    setupTickPath()

    super.layoutSubviews()
  }

  private func setupBackgroundPath() {
    let backgroundPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2)
    backgroundLayer.path = backgroundPath.cgPath
  }

  private func setupTickPath() {
    let tickPath = UIBezierPath()

    let pointA = CGPoint(x: 5, y: 12)
    let pointB = CGPoint(x: 8.24, y: 15.25)
    let pointC = CGPoint(x: 17.2, y: 6.36)

    tickPath.move(to: pointA)
    tickPath.addLine(to: pointB)
    tickPath.addLine(to: pointC)

    tickLayer.frame = bounds
    tickLayer.path = tickPath.cgPath
  }

  private func createCheckPathAnimation() -> CABasicAnimation {
    let beginPathAnimation = CABasicAnimation(keyPath: "strokeEnd")
    beginPathAnimation.duration = 0.22
    beginPathAnimation.fromValue = 0
    beginPathAnimation.toValue = 1
    beginPathAnimation.timingFunction = timingFunction
    beginPathAnimation.isRemovedOnCompletion = true

    return beginPathAnimation
  }

  private func createUncheckedPathAnimation() -> CABasicAnimation {
    let reversePathAnimation = CABasicAnimation(keyPath: "strokeEnd")
    reversePathAnimation.duration = 0.22
    reversePathAnimation.fromValue = 1
    reversePathAnimation.toValue = 0
    reversePathAnimation.timingFunction = timingFunction
    reversePathAnimation.isRemovedOnCompletion = true

    return reversePathAnimation
  }

  private func createUncheckedBackgroundAnimation() -> CABasicAnimation {
    let reverseBackgroundAnimation = CABasicAnimation(keyPath: "fillColor")
    reverseBackgroundAnimation.duration = 0.30
    reverseBackgroundAnimation.fromValue = selectedBackgroundColor.cgColor
    reverseBackgroundAnimation.toValue = unselectedBackgroundColor.cgColor
    reverseBackgroundAnimation.timingFunction = timingFunction
    reverseBackgroundAnimation.isRemovedOnCompletion = true

    return reverseBackgroundAnimation
  }

  private func animateToChecked() {
    let pathAnimation = createCheckPathAnimation()

    tickLayer.strokeEnd = 1.0
    tickLayer.add(pathAnimation, forKey: "strokeEnd")

    backgroundLayer.fillColor = selectedBackgroundColor.cgColor
    backgroundLayer.strokeColor = selectedBackgroundColor.cgColor
    backgroundLayer.setNeedsDisplay()
  }

  private func animateToUnchecked() {
    let reversePathAnimation = createUncheckedPathAnimation()
    let backgroundAnimation = createUncheckedBackgroundAnimation()

    tickLayer.strokeEnd = 0.0
    tickLayer.add(reversePathAnimation, forKey: "strokeEnd")

    backgroundLayer.fillColor = unselectedBackgroundColor.cgColor
    backgroundLayer.strokeColor = UIColor.gray.cgColor

    backgroundLayer.add(backgroundAnimation, forKey: "fillColor")
    backgroundLayer.setNeedsDisplay()
  }

  @objc private func generateHaptic() {
    Haptic.selection.generate(prepareForReuse: true)
  }

  public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let desiredSize = CGSize(width: 44, height: 44)

    let dx = max(desiredSize.width - bounds.width, 0)
    let dy = max(desiredSize.height - bounds.height, 0)
    let hitTestFrame = bounds.insetBy(dx: -dx/2, dy: -dy/2)

    return hitTestFrame.contains(point) ? self : nil
  }
}
