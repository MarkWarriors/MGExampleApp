//
//  ImageViewWithLoader.swift
//
//
//  Created by Marco Guerrieri on 08/04/2021.
//

import UIKit

struct ImageCache {
  static let shared = NSCache<NSString, UIImage>()
}

public final class ImageViewWithLoader: UIView, Parallaxable {

  public enum ImageViewWithLoaderAnimationType {
    case fadeIn
    case circleToRect
  }

  public var imageAppearAnimation: ImageViewWithLoaderAnimationType = .circleToRect
  public var shouldShowBorder: Bool = true {
    didSet {
      borderView.isHidden = !shouldShowBorder
    }
  }

  public var imageContentMode: UIView.ContentMode = .scaleAspectFill {
    didSet {
      imageView.contentMode = imageContentMode
    }
  }

  public var imageBackgroundColor: UIColor = .clear {
    didSet {
      imageView.backgroundColor = imageView.image == nil ? .clear : imageBackgroundColor
    }
  }

  public var shouldPlaceImageBehindBorder = false {
    didSet {
      let frontView = shouldPlaceImageBehindBorder ? borderView : imageView
      bringSubviewToFront(frontView)
    }
  }

  public var borderColor: UIColor = .white {
    didSet {
      borderView.layer.borderColor = borderColor.cgColor
    }
  }

  public var borderWidth: CGFloat = 3 {
    didSet {
      borderView.layer.borderWidth = borderWidth
    }
  }

  public var parallax: CGFloat = 0 {
    didSet {
      configureImageViewYConstraint()
    }
  }

  public var isParallaxEnabled = false {
    didSet {
      setupImageViewHeightConstraint()
    }
  }

  public var parallaxSize: CGFloat = 44 {
    didSet {
      setupImageViewHeightConstraint()
    }
  }

  private var imageViewHeightConstraint: NSLayoutConstraint?
  private var imageViewYConstraint: NSLayoutConstraint?
  private let imageView = UIImageView()
  private let loadingSpinner = UIRefreshControl(frame: .zero)
  private let borderView = UIView()
  private let queue = OperationQueue()
  private let holeView = HoleView()

  convenience init() {
    self.init(frame: .zero)
  }

  // MARK: Public overrides

  override public func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    imageView.layer.cornerRadius = layer.cornerRadius
    borderView.layer.cornerRadius = layer.cornerRadius
  }

  // MARK: Public helpers

  public func loadImage(from url: URL, completion: ((UIImage) -> Void)? = nil) {
    guard let image = ImageCache.shared.object(forKey: NSString(string: url.absoluteString)) else {
      fetchImageFrom(url: url, completion: completion)
      return
    }
    set(image: image, animated: false)
    completion?(image)
  }

  public func set(image: UIImage?, animated: Bool) {
    imageView.image = image
    imageView.backgroundColor = image == nil ? .clear : imageBackgroundColor
    loadingSpinner.alpha = 0
    if animated {
      animateImageAppear()
    } else {
      imageView.alpha = 1
    }
  }

  public func prepareForReuse() {
    queue.cancelAllOperations()
    set(image: nil, animated: false)
    setupImageViewHeightConstraint()
    setupImageViewYConstraint()
    configureImageViewYConstraint()
    loadingSpinner.endRefreshing()
  }

  // MARK: Private functions

  private func fetchImageFrom(url: URL, completion: ((UIImage) -> Void)? = nil) {
    startLoadingImage()
    DispatchQueue.global().async { [weak self] in
      guard
        let data = try? Data(contentsOf: url),
        let downloadedImage = UIImage(data: data)
      else {
        self?.set(image: nil, animated: false)
        return
      }

      DispatchQueue.main.async {
        self?.endLoadingWithImage(downloadedImage, animated: true)
        ImageCache.shared.setObject(downloadedImage, forKey: NSString(string: url.absoluteString))
        completion?(downloadedImage)
      }
    }
  }

  private func startLoadingImage() {
    loadingSpinner.alpha = 1
    loadingSpinner.beginRefreshing()
  }

  private func endLoadingWithImage(_ image: UIImage?, animated: Bool) {
    loadingSpinner.endRefreshing()
    set(image: image, animated: animated)
  }

  private func setup() {
    addBorder()
    addImageView()
    addLoadingSpinner()
    backgroundColor = .gray
    clipsToBounds = true
    translatesAutoresizingMaskIntoConstraints = false
  }

  private func addImageView() {
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    addSubview(imageView)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

    imageView.addSubview(holeView)
    holeView.translatesAutoresizingMaskIntoConstraints = false
    holeView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    holeView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    holeView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    holeView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

    setupImageViewHeightConstraint()
    setupImageViewYConstraint()
    configureImageViewYConstraint()
  }

  private func setupImageViewHeightConstraint() {
    if let heightConstraint = imageViewHeightConstraint {
      removeConstraint(heightConstraint)
    }
    imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: heightAnchor)
    imageViewHeightConstraint?.isActive = true
    imageViewHeightConstraint?.constant = isParallaxEnabled ? parallaxSize : 0
  }

  private func setupImageViewYConstraint() {
    if let constraint = imageViewYConstraint {
      removeConstraint(constraint)
    }
    imageViewYConstraint = imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
    imageViewYConstraint?.isActive = true
  }

  private func configureImageViewYConstraint() {
    let parallaxCappedAtMax = min(1, parallax)
    let parallaxCappedAtMinAndMax = max(-1, parallaxCappedAtMax)
    let parallaxAmount = parallaxCappedAtMinAndMax * (parallaxSize / 2)
    imageViewYConstraint?.constant = CGFloat(isParallaxEnabled ? parallaxAmount : 0)
  }

  private func addBorder() {
    addSubview(borderView)
    borderView.pin(toView: self)
    borderView.backgroundColor = .clear
    borderView.layer.borderColor = borderColor.cgColor
    borderView.layer.borderWidth = borderWidth
  }

  private func addLoadingSpinner() {
    addSubview(loadingSpinner)
    loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
    loadingSpinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    loadingSpinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    loadingSpinner.heightAnchor.constraint(equalToConstant: 100).isActive = true
    loadingSpinner.widthAnchor.constraint(equalToConstant: 100).isActive = true
  }

  private func animateImageAppear() {
    switch imageAppearAnimation {
    case .fadeIn:
      fadeInAnimation()
    case .circleToRect:
      retreatingCircleAnimation()
    }
  }

  private func fadeInAnimation() {
    imageView.alpha = 0
    UIView.animate(withDuration: 0.33,
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    self.imageView.alpha = 1
                   })
  }

  private func retreatingCircleAnimation() {
    holeView.setNeedsLayout()
    holeView.layoutIfNeeded()
    holeView.backgroundColor = backgroundColor
    holeView.layer.borderWidth = borderWidth
    holeView.layer.borderColor = borderColor.cgColor
    holeView.animateAwayHole()
  }

}	
