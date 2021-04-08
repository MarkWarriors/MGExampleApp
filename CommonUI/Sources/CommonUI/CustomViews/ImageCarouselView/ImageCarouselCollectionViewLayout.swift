//
//  ImageCarouselCollectionViewLayout.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public protocol ImageCarouselCollectionViewLayoutDelegate: UICollectionViewDelegateFlowLayout {
  func didChangePage(to index: CGFloat)
}

class ImageCarouselCollectionViewLayout: UICollectionViewLayout {

  private var currentPageIndex: CGFloat = 0 {
    didSet {
      guard let collectionView = collectionView, let layoutDelegate = collectionView.delegate as? ImageCarouselCollectionViewLayoutDelegate else { return }

      layoutDelegate.didChangePage(to: currentPageIndex)
    }
  }
  private var mostVisiblePage: Int = 0
  private var itemCount = 0
  private var cellLayoutAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]

  var cellSizeMaxIncrement: CGFloat = 0.18

  private var visibleRect: CGRect {
    guard let collectionView = collectionView else { return .zero }

    return CGRect(x: collectionView.contentOffset.x, y: collectionView.contentOffset.y, width: collectionView.frame.width, height: collectionView.frame.height)
  }

  override public var collectionViewContentSize: CGSize {
    guard let collectionView = collectionView else { return .zero }

    let contentWidth = collectionView.frame.width * CGFloat(collectionView.numberOfItems(inSection: 0))
    let contentHeight = collectionView.frame.height
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let collectionView = collectionView else { return nil }

    let attributes = UICollectionViewLayoutAttributes.init(forCellWith: itemIndexPath)
    attributes.frame = collectionView.bounds
    attributes.alpha = 0
    attributes.zIndex = itemIndexPath.item
    return attributes
  }

  override func prepare() {
    guard let collectionView = collectionView else { return }

    if cellLayoutAttributes.count == 0 {
      itemCount = collectionView.numberOfItems(inSection: 0)
      for item in 0..<itemCount {
        let indexPath = IndexPath(item: item, section: 0)
        cellLayoutAttributes[indexPath] = initialLayoutAttributesForAppearingItem(at: indexPath)
      }
    }
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let collectionView = collectionView, let attributes = cellLayoutAttributes[indexPath] else { return nil }

    let completion = (collectionView.contentOffset.x / collectionView.frame.size.width) - CGFloat(mostVisiblePage)

    attributes.frame = visibleRect

    switch indexPath.item {
    case mostVisiblePage - 1:
      attributes.transform = CGAffineTransform(scaleX: 1, y: 1)
      attributes.alpha = 1 - completion
    case mostVisiblePage:
      attributes.transform = CGAffineTransform(scaleX: 1, y: 1)
      attributes.alpha = 1
    case mostVisiblePage + 1:
      let resizeScale = 1 + (cellSizeMaxIncrement * (1 - completion))
      attributes.transform = CGAffineTransform(scaleX: resizeScale, y: resizeScale)
      attributes.alpha = completion
      return attributes
    default:
      break
    }
    return attributes
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let collectionView = collectionView else { return nil }

    var attributes: [UICollectionViewLayoutAttributes?] = []

    mostVisiblePage = Int(collectionView.contentOffset.x / collectionView.frame.size.width)
    currentPageIndex = collectionView.contentOffset.x / collectionView.frame.size.width
    let completion = (collectionView.contentOffset.x / collectionView.frame.size.width) - CGFloat(mostVisiblePage)
    let movingPage = completion < 0 ? mostVisiblePage - 1 : mostVisiblePage

    if movingPage > 0 {
      let previousIndexPath = IndexPath(item: movingPage - 1, section: 0)
      attributes.append(layoutAttributesForItem(at: previousIndexPath))
    }

    let currentIndexPath = IndexPath(item: movingPage, section: 0)
    attributes.append(layoutAttributesForItem(at: currentIndexPath))

    if movingPage < itemCount - 1 {
      let nextIndexPath = IndexPath(item: movingPage + 1, section: 0)
      attributes.append(layoutAttributesForItem(at: nextIndexPath))
    }

    return attributes.compactMap{ $0 }
  }
}
