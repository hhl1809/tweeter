//
//  ViewController.swift
//  Tweeter
//
//  Created by HUYNH Hoc Luan on 4/16/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KMPlaceholderTextView

class ViewController: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextView: KMPlaceholderTextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var viewModel: ViewModel?
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerCells()
        initViewModel()
        initRx()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Functions
    func initViewModel() -> Void {
        if viewModel == nil {
            viewModel = ViewModel()
        }
    }
    
    private func registerCells() -> Void {
        tableView.register(UINib(nibName: MessageTableViewCell.cellIdentifier, bundle: Bundle.main), forCellReuseIdentifier: MessageTableViewCell.cellIdentifier)
    }
    
    private func initRx() -> Void {
        setupTableViewRx()
        actionRx()
    }
    
    private func actionRx() -> Void {
        sendButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            if let text = this.viewModel?.handleInputString(string: this.inputTextView.text) {
                this.viewModel?.listMessage?.append(text)
                this.inputTextView.text = ""
                this.viewModel?.initDataFromListMessage()
            } else {
                this.view.makeToast("Your input is not valid")
                this.inputTextView.text = ""
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func setupTableViewRx() -> Void {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(
            configureCell: { (ds, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: MessageTableViewCell.cellIdentifier, for: indexPath) as! MessageTableViewCell
                cell.setupView()
                cell.contentLabel.text = element
                return cell
            },titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].model
        })
        viewModel?.listData?.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.itemSelected.map { indexPath in
            return (indexPath, dataSource[indexPath])
            }.subscribe(onNext: { [weak self] indexPath, object in
                guard let this = self else { return }
                this.tableView.deselectRow(at: indexPath, animated: false)
            }).disposed(by: disposeBag)
    }
    
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}


