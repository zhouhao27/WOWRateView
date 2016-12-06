//
//  RateViewCell.swift
//  WOWRateView
//
//  Created by Zhou Hao on 06/12/16.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import WOWRateView

class RateViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateView: WOWRateView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
