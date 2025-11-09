//
//  HeaderCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit

final class HeaderCell: UICollectionViewCell {
    
    var onSearch: ((String) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ZenWall"
        label.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let searchBar = CustomSearchBar()
    
    private lazy var searchTapButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        btn.tintColor = UIColor(white: 1.0, alpha: 0.85)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(searchTapButton)
        
        searchBar.setDelegate(self)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchTapButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            searchBar.trailingAnchor.constraint(equalTo: searchTapButton.leadingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            searchTapButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchTapButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            searchTapButton.widthAnchor.constraint(equalToConstant: 32),
            searchTapButton.heightAnchor.constraint(equalToConstant: 32),
        ])
        
        searchTapButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
    }
    
    @objc private func searchTapped() {
        onSearch?(searchBar.text)
    }
}

extension HeaderCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onSearch?(searchBar.text)
        textField.resignFirstResponder()
        return true
    }
}
