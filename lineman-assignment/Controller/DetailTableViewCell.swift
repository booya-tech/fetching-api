//
//  DetailTableViewCell.swift
//  lineman-assignment
//
//  Created by Panachai Sulsaksakul on 4/18/23.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var countVote: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var topicName: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
