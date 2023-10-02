//
//  ImageCarouselView.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public protocol ImageCarouselViewDelegate: AnyObject {
  func imageCarouselView(_: ImageCarouselView, didTapImageAtIndex index: Int, in images: ImagesCollectionType)
}

public final class ImageCarouselView: UIView, XIBLoadable {

  public weak var delegate: ImageCarouselViewDelegate?

  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var pageControlContainerView: UIView!
  @IBOutlet private var gradientView: UIView!
  private let gradientLayer = CAGradientLayer()
  private let pageControl = UIPageControl()
  private var images: ImagesCollectionType = .remote(from: [])

  // MARK: Init

  public override func awakeFromNib() {
    super.awakeFromNib()
    setupCollectionView()
    setupPageControl()
    setupGradientLayer()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = gradientView.bounds
  }

  public func parallaxAgainst(view: UIView) {
    collectionView.parallaxVisibleCells(against: view)
  }

  // MARK: Public

  public func configure(with images: ImagesCollectionType) {
    self.images = images
    pageControl.numberOfPages = images.count
    let isLessThanTwoImages = images.count < 2
    pageControl.isHidden = isLessThanTwoImages
    gradientView.isHidden = isLessThanTwoImages
    collectionView.reloadData()
    setupBorderIfRequired()
  }

  public func scroll(to index: Int) {
    let scrollAmount = CGFloat(index) * collectionView.frame.width
    collectionView.contentOffset.x = scrollAmount
  }

  // MARK: Private helpers

  private func setupPageControl() {
    pageControlContainerView.addSubview(pageControl)
    pageControl.pin(toView: pageControlContainerView)
  }

  private func setupGradientLayer() {
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    gradientView.layer.addSublayer(gradientLayer)
  }

  private func setupCollectionView() {
    let nib = UINib(nibName: ImageCarouselCollectionViewCell.reuseIdentifier, bundle: Bundle(for: ImageCarouselCollectionViewCell.self))
    collectionView.register(nib, forCellWithReuseIdentifier: ImageCarouselCollectionViewCell.reuseIdentifier)
    collectionView.collectionViewLayout = ImageCarouselCollectionViewLayout()
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.bounces = false
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPagingEnabled = true
  }

  private func setupBorderIfRequired() {
    if images.count == 0 {
      let borderView = UIView()
      addSubview(borderView)
      borderView.pin(toView: self)
      borderView.backgroundColor = .clear
      borderView.layer.borderColor = UIColor.white.cgColor
      borderView.layer.borderWidth = 3
    }
  }

}

extension ImageCarouselView: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCarouselCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCarouselCollectionViewCell
    configure(cell, at: indexPath)
    return cell
  }

  private func configure(_ cell: ImageCarouselCollectionViewCell, at indexPath: IndexPath) {
    switch images {
    case .local(let localImages):
      let image = localImages[indexPath.row]
      cell.configure(with: image)
    case .remote(let images):
      let imageURL = images[indexPath.row]
      cell.configure(with: imageURL)
    }
  }

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.imageCarouselView(self, didTapImageAtIndex: indexPath.row, in: images)
  }

}

extension ImageCarouselView: ImageCarouselCollectionViewLayoutDelegate {

  public func didChangePage(to index: CGFloat) {
    pageControl.currentPage = Int(index)
  }
}

