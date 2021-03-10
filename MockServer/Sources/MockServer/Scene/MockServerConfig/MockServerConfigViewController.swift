//
//  MockServerConfigViewController.swift
//  
//
//  Created by Marco Guerrieri on 30/03/2021.
//

import UIKit

final class MockServerConfigViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var pickerView: UIPickerView!
  @IBOutlet private var pickerContainerView: UIView!
  @IBOutlet private var pickerContainerViewHeight: NSLayoutConstraint!
  @IBOutlet private var selectedKeyLabel: UILabel!

  private let allRoutesName = Array(MockServerConfig.getAllRoutesAndMapToResponse().keys).sorted()
  private var selectedKey = ""
  private var selectedIndexPath: IndexPath?

  init() {
    super.init(nibName: nil, bundle: .module)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(UINib(nibName: MockServerConfigTableViewCell.reuseIdentifier,
                             bundle: Bundle.module),
                       forCellReuseIdentifier: MockServerConfigTableViewCell.reuseIdentifier)
    tableView.estimatedRowHeight = UITableView.automaticDimension
    tableView.delegate = self
    tableView.dataSource = self

    pickerView.delegate = self
    pickerView.dataSource = self

    pickerView.isHidden = true
    selectedKeyLabel.text = "No route selected"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }

  @IBAction func resetButtonTapped(sender: Any) {
    resetAllRoute()
  }

  private func resetAllRoute() {
    allRoutesName.forEach { (name) in
      MockServerStore.shared.store(key: name, response: .success)
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.tableView.reloadData()
    }

    pickerView.isHidden = true
    selectedKeyLabel.text = "No route selected"
  }
}

extension MockServerConfigViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allRoutesName.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MockServerConfigTableViewCell", for: indexPath) as? MockServerConfigTableViewCell else {
      assertionFailure("No table cell found")
      return UITableViewCell()
    }
    let name = allRoutesName[indexPath.row]
    let status = MockServerStore.shared.get(key: name)
    cell.titleLabel.text = name
    cell.descriptionLabel.text = status?.rawValue
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedKey = allRoutesName[indexPath.row]
    selectedIndexPath = indexPath
    openPicker(selectedKey: selectedKey)
  }

  private func openPicker(selectedKey: String) {
    pickerView.isHidden = false
    guard
      let response = MockServerStore.shared.get(key: selectedKey),
      let currentSelection = MockServerConfig.BasicResponse.allCases.firstIndex(of: response)
    else { return }
    selectedKeyLabel.text = selectedKey
    pickerView.selectRow(currentSelection, inComponent: 0, animated: false)
  }
}

extension MockServerConfigViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return MockServerConfig.BasicResponse.allCases.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return MockServerConfig.BasicResponse.allCases[row].rawValue
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let selectedResponse = MockServerConfig.BasicResponse.allCases[row]
    updateStore(key: selectedKey, response: selectedResponse)
    if let indexPath = selectedIndexPath {
      tableView.reloadRows(at: [indexPath], with: .automatic)
    }
  }

  private func updateStore(key: String, response: MockServerConfig.BasicResponse) {
    MockServerStore.shared.store(key: key, response: response)
  }
}
