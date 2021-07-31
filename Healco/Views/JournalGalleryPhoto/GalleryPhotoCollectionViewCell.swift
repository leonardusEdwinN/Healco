//
//  GalleryPhotoCollectionViewCell.swift
//  Healco
//
//  Created by Edwin Niwarlangga on 16/06/21.
//

import UIKit

class GalleryPhotoCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var viewPhotoGallery: UIView!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var labelTitleGalleryPhoto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        photoView.layer.cornerRadius = 15
        photoView.layer.masksToBounds = true
        labelTitleGalleryPhoto.layer.cornerRadius = 15
        labelTitleGalleryPhoto.layer.masksToBounds = true
        
//        viewPhotoGallery.dropShadow()
        
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        

    }
    
    func setUI(dataPhoto : Photo){
        self.labelTitleGalleryPhoto.text = dataPhoto.title
        self.photoView.image = dataPhoto.image
        
        
    }
    
    
//    func updateUI(){
//        if let photo = photo{
//            photoGalleryView.image = photo.image
////            labelTitleGalleryPhoto.text = photo.title
////            labelDescriptionGalleryPhoto.text = photo.description
//        }else{
//            photoGalleryView.image = nil
////            labelTitleGalleryPhoto.text = "Title Gallery Photo"
////            labelDescriptionGalleryPhoto.text = "Description gallery photo"
//        }
//
//    }

}
