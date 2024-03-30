//
//  StepsAddCell.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/21/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class StepsAddCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    var delegate: AddOrUpdateRecipeVC?
    
    private var cellIndexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.delegate = self
        setupViews()
    }
    
    fileprivate func setupViews() {
        containerView.layer.cornerRadius = 20.0
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
    }
    
    func setData(delegate: AddOrUpdateRecipeVC) {
        self.delegate = delegate
        self.textView.text = ""
    }
    
    func setIndexPath(indexPath: IndexPath) {
        self.cellIndexPath = indexPath
        self.loadData()
    }
    
    func loadData() {
        if let indexPath = self.cellIndexPath {
            let currentStringForTextView = self.delegate?.getSteps(indexPath) ?? ""
            self.textView.text = currentStringForTextView
        }
    }
    
}

extension  StepsAddCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {        
        if let indexPath = self.cellIndexPath {
            delegate?.setSteps(indexPath, stepFromCell: self.textView.text)
        }
    }
}



