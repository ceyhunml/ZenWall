//
//  WallpaperCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import UIKit

final class WallpaperCell: UICollectionViewCell {
    
    var onFavorite: (() -> Void)?
    var onDownload: (() -> Void)?
    var onTap: (() -> Void)?
    
    private let imageView = UIImageView()
    private let gradient = CAGradientLayer()
    private let overlayView = UIView()
    private let favoriteButton = UIButton(type: .system)
    private let downloadButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor
        ]
        gradient.locations = [0.7, 1.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        imageView.layer.insertSublayer(gradient, at: 0)
        
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        overlayView.alpha = 0
        overlayView.layer.cornerRadius = 16
        imageView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
        overlayView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        setupButtons()
    }
    
    private func setupButtons() {
        [favoriteButton, downloadButton].forEach {
            $0.tintColor = .white
            $0.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
            $0.layer.cornerRadius = 16
            $0.translatesAutoresizingMaskIntoConstraints = false
            imageView.addSubview($0)
        }
        
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        downloadButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        
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
        
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadTapped), for: .touchUpInside)
    }
    
    // MARK: - Gestures
    private func setupGesture() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.minimumPressDuration = 0.05
        contentView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            animateOverlay(show: true)
        case .ended, .cancelled, .failed:
            animateOverlay(show: false)
            onTap?()
        default:
            break
        }
    }
    
    private func animateOverlay(show: Bool) {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.4,
                       options: [.curveEaseOut]) {
            self.overlayView.alpha = show ? 1 : 0
            self.overlayView.transform = show ? .identity : CGAffineTransform(scaleX: 0.6, y: 0.6)
        }
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = imageView.bounds
    }
    
    // MARK: - Configure
    func configure(imageURL: String) {
        if let url = URL(string: imageURL) {
            imageView.kf.setImage(with: url, options: [.transition(.fade(0.3)), .cacheOriginalImage])
        }
    }
    
    // MARK: - Actions
    @objc private func favoriteTapped() {
        onFavorite?()
    }
    
    @objc private func downloadTapped() {
        onDownload?()
    }
}
