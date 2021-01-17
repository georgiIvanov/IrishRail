//
//  UITextField+Extensions.swift
//  IrishRailAPI
//
//  Created by Voro on 16.01.21.
//

import Foundation
import RxSwift
import RxCocoa

extension UITextField {
    func makeBorderOnTap(width: CGFloat = 2, color: UIColor = AppConfig.appMainColor) -> [Disposable] {
        
        let originalWidth = layer.borderWidth
        let originalColor = layer.borderColor
    
        let disp1 = rx.controlEvent([.editingDidBegin]).asObservable()
        .subscribe(onNext: { [weak self] _ in
            self?.layer.borderWidth = width
            self?.layer.borderColor = color.cgColor
        })
        
        let disp2 = rx.controlEvent([.editingDidEnd]).asObservable()
        .subscribe(onNext: { [weak self, originalWidth = originalWidth, originalColor = originalColor] _ in
            self?.layer.borderWidth = originalWidth
            self?.layer.borderColor = originalColor
        })
        
        return [disp1, disp2]
    }
}
