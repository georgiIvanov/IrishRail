//
//  TrainStopView.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import UIKit

@IBDesignable
class TrainStopView: UIView {
    
    @IBInspectable
    var direction: String = "to/from"
    
    @IBInspectable
    var location: String = "Location"
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    public var contentView: UIView?
    
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
        layer.cornerRadius = 4
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
