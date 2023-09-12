//
//  FsWipeView.swift
//  Move004
//
//  Created by apple on 05/09/2023.
//

import Foundation
import UIKit
class FsWipeView: UIView {
    @IBOutlet weak var ivProfile: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        let nib = UINib(nibName: "FsWipeView", bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
            
        }
    }
}
