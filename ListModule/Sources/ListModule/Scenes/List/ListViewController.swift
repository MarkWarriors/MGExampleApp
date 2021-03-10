//
//  ListViewController.swift
//  MGExampleApp
//
//  Created by Marco Guerrieri on 17/12/2020.
//

import UIKit
import CommonUI
import Networking
import CommonDomain
import CommonComponents

final class ListViewController: UIViewController {
  @IBOutlet private var headerContainerView: UIView!
  @IBOutlet private var imageOnTop: UIImageView!
  @IBOutlet private var stickyHeaderView: UIView!
  @TitleLabel() @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var tableView: UITableView!

  @IBOutlet private var headerTopMargin: NSLayoutConstraint!
  @IBOutlet private var tableTopMargin: NSLayoutConstraint!

  private let presenter: ListViewPresenterType

  private let refreshControl = UIRefreshControl()
  private var maxHeaderMovement: CGFloat = 0.0
  private var events: [Event] = []


  init(presenter: ListViewPresenterType) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.setup(with: self)
    configureTableView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    style()
    refreshControl.restartSpinnerAnimationIfNeeded()
  }

  private func style() {
    titleLabel.font = Fonts.Cyberpunk.h1
    titleLabel.textColor = Colors.primaryText
    let placeholderHeader = UIView(frame: headerContainerView.frame)
    placeholderHeader.backgroundColor = .clear
    tableView.tableHeaderView = placeholderHeader
    tableTopMargin.constant = stickyHeaderView.frame.height
    maxHeaderMovement = headerContainerView.frame.maxY
  }

  private func configureTableView() {
    tableView.register(UINib(nibName: EventTableViewCell.reuseIdentifier, bundle: .module), forCellReuseIdentifier: "EventTableViewCell")
    tableView.tableFooterView = UIView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableView.automaticDimension
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self,
                             action: #selector(pulledToRefresh),
                             for: .valueChanged)
  }

  @objc private func pulledToRefresh() {
    presenter.userPulledToRefresh()
  }
}

extension ListViewController: ListViewPresentable {
  func configure(with viewModel: ListViewModel) {
    title = viewModel.navBarTitle
    imageOnTop.image = viewModel.imageOnTop
    titleLabel.text = viewModel.titleLabel
  }

  func startLoading() {
    refreshControl.beginRefreshing()
    refreshControl.restartSpinnerAnimationIfNeeded()
    imageOnTop.alpha = 0.2
    titleLabel.alpha = 0.2
  }

  func endLoading() {
    refreshControl.endRefreshing()
    imageOnTop.alpha = 1
    titleLabel.alpha = 1
  }

  func update(with events: [Event]) {
    self.events = events
    tableView.reloadData()
  }

  func showError(viewModel: ListViewErrorViewModel) {
    let alert = UIAlertController(title: viewModel.title,
                                  message: viewModel.message,
                                  preferredStyle: .alert)

    if let retryActionTitle = viewModel.retryAction {
      let retryAction = UIAlertAction(title: retryActionTitle,
                                      style: .default) { [weak self] _ in
        self?.presenter.retryOnErrorAlertTapped()
      }
      alert.addAction(retryAction)
    }

    let cancelAction = UIAlertAction(title: viewModel.cancelAction,
                                    style: .cancel)
    alert.addAction(cancelAction)
    present(alert, animated: true, completion: nil)
  }
}

extension ListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
      assertionFailure("No table cell found")
      return UITableViewCell()
    }

    let event = events[indexPath.row]

    let newViewModel = EventTableViewCellViewModel(title: event.name,
                                                     description: event.description)

    cell.configure(with: newViewModel)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let event = events[indexPath.row]
    presenter.didTapOnEvent(event)
  }

}

extension ListViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var changed = false
    if abs(headerTopMargin.constant) <= maxHeaderMovement {
      changed = true
      headerTopMargin.constant = max(-scrollView.contentOffset.y,
                                     -maxHeaderMovement)
    } else if -scrollView.contentOffset.y > headerTopMargin.constant {
      changed = true
      headerTopMargin.constant = -scrollView.contentOffset.y
    } else {
      headerTopMargin.constant = -scrollView.contentOffset.y
    }

    if changed {
      let imageTransformation = 1 - (max(min(1, (-headerTopMargin.constant / maxHeaderMovement)/2), 0))
      if imageTransformation > 0.49 {
        imageOnTop.transform = CGAffineTransform(scaleX: imageTransformation,
                                                 y: imageTransformation)
      }
    }
  }
}

