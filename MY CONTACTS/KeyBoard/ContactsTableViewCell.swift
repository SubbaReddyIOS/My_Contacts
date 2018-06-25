//
//  ContactsTableViewCell.swift
//  MY CONTACTS
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblCountryName: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
