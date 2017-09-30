//
//  FeaturedProfilesCell.swift
//  Swap
//
//  Created by David Slakter on 3/5/17.
//
//

import UIKit


class FeaturedProfilesCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    private let cellId = "profilesCellId"
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let profilesCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    func setupView(){
        
        backgroundColor = UIColor.clear
        
        addSubview(profilesCollectionView)
        
        profilesCollectionView.dataSource = self
        profilesCollectionView.delegate = self
        
        profilesCollectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v0]-12-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profilesCollectionView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[v0]-15-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": profilesCollectionView]))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    class ProfileCell: UICollectionViewCell {
        
        override init(frame: CGRect){
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let imageView: UIImageView = {
           
            let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "DefaultProfileImage")
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            
            return iv
        }()
        
        let nameLabel: UILabel = {
           
            let label = UILabel()
            label.text = "Featured"
            label.font = UIFont.systemFont(ofSize: 12)
            label.textAlignment = .center
            
            return label
            
        }()
        
        func setupView(){
  
            addSubview(imageView)
            addSubview(nameLabel)
            
            imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
            nameLabel.frame = CGRect(x: 0, y: (frame.height/2) + 20, width: frame.width, height: 40)
        }
    }
}

