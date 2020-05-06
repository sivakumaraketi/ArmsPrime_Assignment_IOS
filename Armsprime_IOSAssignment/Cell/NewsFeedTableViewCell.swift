//
//  NewsFeedTableViewCell.swift
//  Armsprime_IOSAssignment
//
//  Created by Amsys on 30/01/20.
//  Copyright © 2020 SivaKumarAketi. All rights reserved.
//

import UIKit

class NewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var newsPublishedAt: UILabel!
    @IBOutlet weak var newsauthor: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.hidesWhenStopped = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
