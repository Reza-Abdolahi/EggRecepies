//
//  DetailCell.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/18/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    var stringForCell:String!{
        didSet{
            textView.text = stringForCell
            layer.cornerRadius = 40.0
        }
    }
}
