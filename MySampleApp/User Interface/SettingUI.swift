//
//  SettingUI.swift
//  Swap
//
//  Created by David Slakter on 1/17/17.
//
//

import Foundation

func circularImage(photoImageView: UIImageView?)
{
    photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
    photoImageView!.layer.borderColor = (UIColor.black).cgColor//UIColor.init(red: 36, green: 174, blue: 199, alpha: 1).cgColor
    photoImageView!.layer.cornerRadius = photoImageView!.frame.height/2
    photoImageView!.layer.masksToBounds = false
    photoImageView!.clipsToBounds = true
    photoImageView!.layer.borderWidth = 1.0
    photoImageView!.contentMode = UIViewContentMode.scaleAspectFill
}
func circularImageNoBorder(photoImageView: UIImageView?){
    photoImageView!.layer.frame = photoImageView!.layer.frame.insetBy(dx: 0, dy: 0)
    photoImageView!.layer.borderColor = (UIColor.clear).cgColor
    photoImageView!.layer.cornerRadius = photoImageView!.frame.height/2
    photoImageView!.layer.masksToBounds = false
    photoImageView!.clipsToBounds = true
    photoImageView!.layer.borderWidth = 1.0
    photoImageView!.contentMode = UIViewContentMode.scaleAspectFill
}
