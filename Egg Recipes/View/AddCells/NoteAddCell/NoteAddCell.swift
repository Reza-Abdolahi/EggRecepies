//
//  NoteAddCell.swift
//  Egg Recipes
//
//  Created by Reza Abdolahi on 6/21/19.
//  Copyright © 2019 Reza Abdolahi. All rights reserved.
//

import UIKit

class NoteAddCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    var delegate: AddOrUpdateRecipeVC?
    
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
    
    func loadData() {
        let currentStringForTextView = self.delegate?.getNote()
        self.textView.text = currentStringForTextView
    }
    
}

extension NoteAddCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
            delegate?.setNote(noteFromCell: self.textView.text)
    }
}

