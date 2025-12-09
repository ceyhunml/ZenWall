//
//  CustomSearchBar.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.11.25.
//

import Foundation
import UIKit

final class CustomSearchBar: UIView {
    
    // MARK: - UI
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iv.tintColor = UIColor(white: 1.0, alpha: 0.8)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.textColor = .white
        tf.tintColor = .white
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        
        let placeholder = "Search for colors, styles, etc."
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor(white: 1.0, alpha: 0.6),
                .font: UIFont.systemFont(ofSize: 16, weight: .medium)
            ]
        )
        return tf
    }()
    
    // MARK: - Public properties
    var text: String {
        textField.text ?? ""
    }
    
    var onTextChanged: ((String) -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = UIColor(red: 0.12, green: 0.23, blue: 0.19, alpha: 1.0)
        layer.masksToBounds = true
        
        addSubview(iconImageView)
        addSubview(textField)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupActions() {
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: - Public
    func setDelegate(_ delegate: UITextFieldDelegate?) {
        textField.delegate = delegate
    }
}
