//
//  HeaderCell.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit

final class HeaderCell: UICollectionViewCell, UITextFieldDelegate {
    
    // MARK: - Callback
    var onSearch: ((String) -> Void)?
    
    // MARK: - UI
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
        btn.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        btn.tintColor = UIColor(white: 1.0, alpha: 0.85)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupSearchEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(searchTapButton)
        
        searchBar.setDelegate(self)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchTapButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchTapButton.leadingAnchor, constant: -8),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            searchTapButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            searchTapButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            searchTapButton.widthAnchor.constraint(equalToConstant: 32),
            searchTapButton.heightAnchor.constraint(equalToConstant: 32),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Events
    private func setupSearchEvents() {
        searchBar.onTextChanged = { [weak self] text in
            guard let self else { return }
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.onSearch?("")
            }
        }
    }
    
    @objc private func searchTapped() {
        onSearch?(searchBar.text)
        endEditing(true)
    }
    
    func resetSearch() {
        searchBar.textField.text = ""
    }
}
