//
//  ImageCarouselCollectionViewCell.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

public final class ImageCarouselCollectionViewCell: UICollectionViewCell, XIBLoadable, Parallaxable {

  public static let reuseIdentifier = "ImageCarouselCollectionViewCell"

  @IBOutlet private var carouselItemImageView: ImageViewWithLoader! {
    didSet {
      carouselItemImageView.backgroundColor = .systemGroupedBackground
      carouselItemImageView.imageAppearAnimation = .fadeIn
      carouselItemImageView.shouldShowBorder = false
      carouselItemImageView.isParallaxEnabled = true
      carouselItemImageView.parallaxSize = 88
    }
  }

  public var parallax: CGFloat = 0 {
    didSet {
      carouselItemImageView.parallax = parallax
    }
  }

  func configure(with url: URL) {
    carouselItemImageView.loadImage(from: url)
  }

  func configure(with image: UIImage) {
    carouselItemImageView.set(image: image, animated: false)
  }

}
