//
//  MessageTableViewCell.swift
//  Tweeter
//
//  Created by HUYNH Hoc Luan on 4/17/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MessageTableViewCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK: - Properties
    static let cellIdentifier = "MessageTableViewCell"
    var object: Any?
    var cellName: String = ""
    var isSelect: Bool = false
    var disposeBag = DisposeBag()
    
    // MARK: - Functions
    func setupView() -> Void {
        boundView.layer.cornerRadius = 5
        boundView.setShadow()
    }
    
}
