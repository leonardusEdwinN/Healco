//
//  WeeklyCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 17/06/21.
//

import UIKit

protocol WeeklyCollectionViewCellProtocol {
    func reloadCell()
}

class WeeklyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    
//    var selectedCell: Bool = false {
//        didSet{
//            self.changeUpdate()
//        }
//    }
    
//    var delegate : WeeklyCollectionViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(dateText : String){
        self.labelDate.text = dateText
        imageIcon.image = UIImage(systemName: "circle.fill")
    }
    
    func changeUpdate(status: String){
//        print("CELL : \(selectedCell) :: isselected \(isSelected)")
        if(status == "Healthy"){
            imageIcon.image = UIImage(systemName: "heart.fill")
            imageIcon.tintColor = .red
        }else if (status == "Unhealthy"){
            imageIcon.image = UIImage(systemName: "hand.thumbsdown.fill")
            imageIcon.tintColor = .red
        }else{
            imageIcon.image = UIImage(systemName: "circle.fill")
            imageIcon.tintColor = .secondaryLabel
        }
        
//        delegate?.reloadCell()
    }
    

}
