//
//  WallpaperCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class WallpaperCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var downloadButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        btn.layer.cornerRadius = 16
        btn.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        btn.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
        return btn
    }()
    
    var onFavorite: (() -> Void)?
    var onDownload: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        [favoriteButton, downloadButton].forEach { imageView.addSubview($0) }
        
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 10),
            favoriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 32),
            favoriteButton.heightAnchor.constraint(equalToConstant: 32),
            
            downloadButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -10),
            downloadButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(equalToConstant: 32),
            downloadButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(imageURL: String) {
        imageView.setUnsplashImage(imageURL)
    }
    
    @objc private func favoriteTapped() { onFavorite?() }
    @objc private func downloadTapped() { onDownload?() }
}
