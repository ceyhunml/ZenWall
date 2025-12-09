//
//  ProfileViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.12.25.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Profile"
        lbl.font = .systemFont(ofSize: 20, weight: .bold)
        lbl.textColor = UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 64
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.textColor = UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var listContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.layer.cornerRadius = 16
        stack.clipsToBounds = true
        stack.backgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.16, alpha: 1)
        return stack
    }()
    
    var viewModel = ProfileViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        fillData()
    }
    
    private func makeRow(icon: String, title: String, isDestructive: Bool = false, action: Selector? = nil) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.16, alpha: 1)
        container.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = isDestructive ? .systemRed : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1)
        iconView.contentMode = .center
        iconView.backgroundColor = (isDestructive ? UIColor.systemRed.withAlphaComponent(0.15) : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1).withAlphaComponent(0.2))
        iconView.layer.cornerRadius = 12
        iconView.clipsToBounds = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = isDestructive ? .systemRed : UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        container.addSubview(iconView)
        container.addSubview(titleLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        if let action {
            let tap = UITapGestureRecognizer(target: self, action: action)
            container.addGestureRecognizer(tap)
        }
        
        return container
    }
    
    // MARK: - Fill UI
    private func fillData() {
        nameLabel.text = viewModel.username
        
        if viewModel.avatarURL.isEmpty {
            avatarImageView.image = UIImage(named: "placeholder-avatar")
        } else {
            avatarImageView.setUnsplashImage(viewModel.avatarURL)
        }
    }
    
    // MARK: - Layout
    private func layoutUI() {
        view.addSubview(titleLabel)
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(listContainer)
        
        [
            makeRow(icon: "help_outline", title: "Help & Support"),
            makeRow(icon: "thumb_up", title: "Rate ZenWall"),
            makeRow(icon: "lock", title: "Privacy Policy"),
            makeRow(icon: "logout", title: "Sign Out", isDestructive: true, action: #selector(signOutTapped))
        ].forEach { listContainer.addArrangedSubview($0) }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        listContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalToConstant: 128),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            listContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            listContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            listContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    @objc private func signOutTapped() {
        let alertForSignOut = UIAlertController(title: "Signing out", message: "Are you sure?", preferredStyle: .alert)
        alertForSignOut.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.viewModel.signOut()
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                if let window = sceneDelegate.window {
                    UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                        window.rootViewController = LoginViewController()
                    }, completion: nil)
                }
            }
        })
        alertForSignOut.addAction(yesAction)
        present(alertForSignOut, animated: true)
    }
}
