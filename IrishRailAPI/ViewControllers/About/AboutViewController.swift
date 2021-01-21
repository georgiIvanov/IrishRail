//
//  AboutViewController.swift
//  IrishRailAPI
//
//  Created by Voro on 20.01.21.
//

import UIKit
import RxSwift
import RxCocoa

class AboutViewController: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var appVersionLabel: UILabel!
    @IBOutlet var examplesLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        
    }
    
    func setupUI() {
        examplesLabel.text = """
            Examples:
            Dublin Connolly - Shankill
            Adamstown (ADMTN) - Grand Canal Dock
            Greystones - Sandymount
            """
        
        appVersionLabel.text = AppConfig.getAppVersion()
    }
    
    func bindUI() {
        closeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
