//
//  MyTableViewCell.swift
//  Challanger
//
//  Created by Saltanat Aimakhanova on 11/14/16.
//  Copyright © 2016 saltaim. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    init(challange: Challange, style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.text = challange.name
        contentView.addSubview(label)


    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    

    
}
