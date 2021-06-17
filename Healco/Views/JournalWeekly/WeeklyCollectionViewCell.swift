//
//  WeeklyCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 17/06/21.
//

import UIKit

class WeeklyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(dateText : String){
        self.labelDate.text = dateText
        imageIcon.image = UIImage(systemName: "heart")
    }
    
    func changeUpdate(){
        if(isSelected){
            imageIcon.image = UIImage(systemName: "heart.fill")
        }else{
            imageIcon.image = UIImage(systemName: "heart")
        }
    }

}
