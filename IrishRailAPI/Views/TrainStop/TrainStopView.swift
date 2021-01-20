//
//  TrainStopView.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

@IBDesignable
class TrainStopView: UIView {
    
    @IBInspectable
    var direction: String = "to/from"
    
    @IBInspectable
    var location: String = "Location"
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    
    public var contentView: UIView?
    public var onViewTap: ((TrainStopView) -> Void)?
    public var onClearButtonTap: ((TrainStopView) -> Void)?
    
    private var inactiveColor = UIColor(red: 0.60, green: 0.59, blue: 0.58, alpha: 1.00)
    private var activeColor = UIColor(red: 0.15, green: 0.15, blue: 0.12, alpha: 1.00)
    let disposeBag = DisposeBag()
    
    open var nibName: String {
        String(describing: TrainStopView.self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        nibSetup()
        contentView?.layer.cornerRadius = 6
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        addGestureRecognizer(gesture)
        
        clearButton.rx.tap.subscribe(onNext: { [weak self] _ in
            if let view = self {
                view.onClearButtonTap?(view)
            }
        }).disposed(by: disposeBag)
    }
    
    @objc func viewTap() {
        onViewTap?(self)
    }
    
    func setLocationText(_ text: String?) {
        guard let text = text else {
            locationLabel.textColor = inactiveColor
            locationLabel.text = location
            clearButton.isHidden = true
            return
        }
        
        locationLabel.text = text
        locationLabel.textColor = activeColor
        clearButton.isHidden = false
    }
    
    open func nibSetup() {
        let view = loadViewFromNib(nibName)
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        backgroundColor = .clear
        addSubview(view)
        contentView = view
        
        directionLabel.text = direction
        locationLabel.text = location
        locationLabel.textColor = inactiveColor
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        nibSetup()
        contentView?.prepareForInterfaceBuilder()
    }
    
    func loadViewFromNib(_ nibName: String) -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self)[0] as? UIView else {
            fatalError("Could not load nib with name \(nibName)")
        }
        
        return view
    }
}
