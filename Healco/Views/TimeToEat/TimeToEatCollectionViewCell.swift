//
//  TimeToEatCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 25/06/21.
//

import UIKit

class TimeToEatCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelTimeToEat: UILabel!
    @IBOutlet weak var viewTimeToEat: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewTimeToEat.layer.cornerRadius = 15
        viewTimeToEat.layer.masksToBounds = true
        
        // Initialization code
    }
    
    func setUI(timeToEat : String){
        self.labelTimeToEat.text = timeToEat
    }

}
