//
//  PlayerListTableViewCell.swift
//  Assignment
//
//  Created by Amrita Ghosh on 06/02/19.
//  Copyright © 2019 Amrita Ghosh. All rights reserved.
//

import UIKit

class PlayerListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var team: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var profileImg: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCellUsingModel(_ playerList : PlayerList) {
        name.text = playerList.name! + "Team"
        team.text = playerList.team! + "Team"
        age.text = String(playerList.age) + "Age"
        category.text = playerList.category_name! + "Category"
        price.text = playerList.base_price! + "Price"
        
        if let imgUrl = URL.init(string: playerList.picture!) {
            let imageData = NSData(contentsOf: imgUrl as URL)
            let image = UIImage(data: imageData! as Data)
            profileImg.image = image
             // NotificationCenter.default.post(name: Notification.Name(rawValue: ImageObserverKey.imageRecieved), object: nil)
        }
        
    //   profileImg.image = playerList.picture

    }

}
