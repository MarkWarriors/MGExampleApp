//
//  HoleView.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

final class HoleView: UIView {
  
  private let maskLayer = CAShapeLayer()
  private var squarePath: UIBezierPath {
    let startingSquarePath = UIBezierPath(rect: CGRect(x: -1, y: -1, width: frame.width + 2, height: frame.height + 2))
    return startingSquarePath
  }
  
  func animateAwayHole() {
    let startingCompletePath = startPath(frame: bounds)
    let endingCompletePath = endingPath(frame: bounds)
    
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = 0.3
    animation.toValue = endingCompletePath
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    
    maskLayer.backgroundColor = UIColor.clear.cgColor
    maskLayer.path = startingCompletePath
    maskLayer.fillRule = .evenOdd
    maskLayer.bounds = bounds
    maskLayer.anchorPoint = .zero
    layer.mask = maskLayer
    let animationKey = "animateAwayHole"
    maskLayer.removeAnimation(forKey: animationKey)
    maskLayer.add(animation, forKey: animationKey)
  }
  
  private func startPath(frame: CGRect) -> CGPath {
    let startingSquarePath = squarePath
    let startingCirclePath = UIBezierPath(roundedRect: CGRect(x: frame.midX, y: frame.midY, width: 0, height: 0), cornerRadius: 0)
    startingSquarePath.append(startingCirclePath)
    let startingCompletePath = startingSquarePath.cgPath
    return startingCompletePath
  }
  
  private func endingPath(frame: CGRect) -> CGPath {
    let heightSquared = frame.height * frame.height
    let widthSquared = frame.width * frame.width
    let endCircleDiameter = (heightSquared + widthSquared).squareRoot()
    
    let xOffset = (-endCircleDiameter / 2) + (frame.width / 2)
    let yOffset = (-endCircleDiameter / 2) + (frame.height / 2)
    
    let endingSquarePath = squarePath
    let endingCirclePath = UIBezierPath(roundedRect: CGRect(x: xOffset, y: yOffset, width: endCircleDiameter, height: endCircleDiameter), cornerRadius: endCircleDiameter / 2)
    endingSquarePath.append(endingCirclePath)
    let endingCompletePath = endingSquarePath.cgPath
    return endingCompletePath
  }
  
}
