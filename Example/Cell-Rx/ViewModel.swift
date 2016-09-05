//
//  ViewModel.swift
//  Cell-Rx
//
//  Created by Ivan Bruel on 07/03/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift

class ViewModel: NSObject {

  fileprivate static let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit. Eius adipisci, sed libero. Iste asperiores suscipit, consequatur debitis animi impedit numquam facilis iusto porro labore dolorem, maxime magni incidunt. Delectus, est!".components(separatedBy: " ")

  let string: Variable<String>

  override init() {
    let randomIndex = Int(arc4random_uniform(UInt32(ViewModel.loremIpsum.count)))
    string = Variable(ViewModel.loremIpsum[randomIndex])
  }

}
