//
//  CategoryCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit
import Kingfisher

final class CategoryCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let gradientView = UIView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // ImageView
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
        
        // ✅ GradientView (şəkildən ayrı overlay)
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 16
        contentView.addSubview(gradientView)
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // ✅ Gradient layer — daha dərin və aşağıdan gələn effekt
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.65).cgColor
        ]
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
        
        // Overlay (tap effekti)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        overlayView.alpha = 0
        overlayView.layer.cornerRadius = 16
        contentView.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        overlayView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        // Label
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.numberOfLines = 1
        titleLabel.layer.shadowColor = UIColor.black.cgColor // ✅ yazı kölgəsi
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        overlayView.alpha = 0
    }
    
    func configure(with model: CategoryModel) {
        titleLabel.text = model.name
        imageView.image = nil
        
        // Gradient dərhal görünür, şəkil gəlməsə belə
        if let url = URL(string: model.imageURL) {
            imageView.kf.setImage(
                with: url,
                placeholder: nil,
                options: [.transition(.none), .cacheOriginalImage]
            )
        }
    }
}
