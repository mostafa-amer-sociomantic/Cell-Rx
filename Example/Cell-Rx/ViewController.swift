//
//  ViewController.swift
//  Cell-Rx
//
//  Created by Ivan Bruel on 03/07/2016.
//  Copyright (c) 2016 Ivan Bruel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Cell_Rx

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let disposeBag = DisposeBag()

  let viewModels: Variable<[ViewModel]> = Variable<[ViewModel]>([])

  override func viewDidLoad() {
    super.viewDidLoad()
    for _ in 0..<100 {
      viewModels.value.append(ViewModel())
    }
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    viewModels
      .asObservable()
      .bindTo(tableView.rx_itemsWithCellFactory) {
        (tableView, index, viewModel) -> UITableViewCell in
        guard let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell"),
        textLabel = cell.textLabel else {
          return UITableViewCell()
        }
        viewModel
          .string
          .asObservable()
          .debug()
          .bindTo(textLabel.rx_text)
          .addDisposableTo(cell.rx_reusableDisposeBag)
        return cell
      }.addDisposableTo(disposeBag)
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}

