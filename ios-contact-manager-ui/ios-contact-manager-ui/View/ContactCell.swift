//
//  ContactCell.swift
//  ios-contact-manager-ui
//
//  Created by 김준성 on 10/18/23.
//

import UIKit

class ContactCell: UITableViewCell, ReuseIdentiFiable {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.accessoryType = .disclosureIndicator
    }
    
    func configureCell(_ info: (image: UIImage?, name: String, age: String, phoneNumber: String)) {
        thumbnailImage.image = info.image
        nameLabel.text = info.name
        ageLabel.text = info.age
        phoneNumberLabel.text = info.phoneNumber
    }
    
}


