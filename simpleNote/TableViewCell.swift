//
//  TableViewCell.swift
//  simpleNote
//
//  Created by Ani on 11/4/19.
//  Copyright © 2019 Ani. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(note: Note) {
        self.nameLabel.text = note.noteName
        self.descriptionLabel.text = note.noteDescripton
    }
}
