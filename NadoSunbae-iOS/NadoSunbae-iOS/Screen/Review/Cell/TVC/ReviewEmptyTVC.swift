//
//  ReviewEmptyTVC.swift
//  NadoSunbae-iOS
//
//  Created by EUNJU on 2022/01/21.
//

import UIKit

class ReviewEmptyTVC: BaseTVC {
    @IBOutlet weak var emptyView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension ReviewEmptyTVC {
    private func configureUI() {
        emptyView.makeRounded(cornerRadius: 8.adjusted)
        emptyView.layer.borderColor = UIColor.gray0.cgColor
        emptyView.layer.borderWidth = 1
    }
}
