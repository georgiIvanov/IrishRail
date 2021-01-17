//
//  TrainStationsFilterViewController.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TrainStationsFilterViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var stationTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TrainStationsFilterViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Binding has to be done after table view is added to the view hierarchy
        // hense doing it here. 
        if tableView.dataSource == nil {
            viewModel.filteredStations
            .drive(tableView.rx.items(cellIdentifier: "trainStationCell",
                                      cellType: TrainStationCell.self)) { (_, trainStation, cell) in
                cell.setup(trainStation)
            }.disposed(by: disposeBag)
        }
    }
    
    func setupUI() {
        stationTextField.layer.cornerRadius = 6
        stationTextField.layer.borderWidth = 1
        stationTextField.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func bindUI() {
        disposeBag.insert(stationTextField.makeBorderOnTap())
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

        stationTextField.rx.value.distinctUntilChanged()
        .subscribe(onNext: { [weak self] (text) in
            guard let text = text else {
                return
            }
            
            self?.viewModel.filterByName(text)
        }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
