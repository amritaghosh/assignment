//
//  BaseTableViewCell.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class FilterHeaderView: UITableViewCell {
    
    @IBOutlet weak var backgroundHeaderView: UIView!
    @IBOutlet weak var title: UILabel!
}

class FilterListCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configureCellUsingModel(_ filterList : Filter) {
        title.text = filterList.filterName
    }
}

