//
//  LogbookTableViewCell.swift
//  SkydiveBook
//
//  Created by Guillaume Gutkin-Nicolas on 4/9/18.
//  Copyright © 2018 Guillaume Gutkin-Nicolas. All rights reserved.
//
import UIKit

class LogbookTableViewCell: UITableViewCell {
    //Link the text fields to variables
    @IBOutlet var jumpNum: UILabel!
    @IBOutlet var location: UILabel!
    @IBOutlet var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
