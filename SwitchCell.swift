//
//  SwitchCell.swift
//  Yelp
//
//  Created by Stef Epp on 2/21/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    optional func switchCell(switchCell: SwitchCell, didChangeValue value:Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var SwitchLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onSwitch.addTarget(self, action: "SwitchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func switchValueChanged() {
        print("switch vlaue changed")
        if delegate != nil {
            delegate!.switchCell?(self, didChangeValue: onSwitch.on)
        }
    }

}
