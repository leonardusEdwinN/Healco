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
        
        viewPhotoGallery.layer.cornerRadius = 15
        viewPhotoGallery.layer.masksToBounds = true
        photoView.layer.cornerRadius = 15
        photoView.layer.masksToBounds = true
        labelTitleGalleryPhoto.layer.cornerRadius = 15
        labelTitleGalleryPhoto.layer.masksToBounds = true

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
