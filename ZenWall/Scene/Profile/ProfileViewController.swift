//
//  ProfileViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.12.25.
//

import UIKit
import StoreKit
import SafariServices

final class ProfileViewController: BaseViewController {
    
    // MARK: - UI Elements
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 64
        iv.clipsToBounds = true
        iv.image = UIImage(named: "placeholderAvatar")
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var editPhotoButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        btn.layer.cornerRadius = 18
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        return btn
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 22, weight: .bold)
        lbl.textColor = UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var listContainer: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 0
        s.backgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.16, alpha: 1)
        s.layer.cornerRadius = 16
        s.clipsToBounds = true
        return s
    }()
    
    private lazy var versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "ZenWall v1.0.0"
        lbl.textColor = UIColor(white: 0.7, alpha: 1) // boz rəng
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let imagePicker = UIImagePickerController()
    private let viewModel = ProfileViewModel()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatarTap()
        setupPicker()
        layoutUI()
        bindViewModel()
        viewModel.loadUser()
    }
    
    
    // MARK: - Row Builder
    private func makeRow(icon: String, title: String, isDestructive: Bool = false, action: Selector? = nil) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.16, alpha: 1)
        container.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = isDestructive
        ? UIColor.systemRed.withAlphaComponent(0.18)
        : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1).withAlphaComponent(0.18)
        
        iconContainer.layer.cornerRadius = 8
        iconContainer.clipsToBounds = true
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = isDestructive
        ? .systemRed
        : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1)
        
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = isDestructive
        ? .systemRed
        : UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
        titleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        container.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        container.addSubview(titleLabel)
        
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            iconContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])
        
        if let action {
            let tap = UITapGestureRecognizer(target: self, action: action)
            container.addGestureRecognizer(tap)
        }
        
        return container
    }
    
    
    // MARK: - Tap Avatar → Picker
    private func setupAvatarTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    private func setupPicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        
        viewModel.onDataLoaded = { [weak self] fullname, email, photoURL in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.nameLabel.text = fullname
                
                if let url = photoURL {
                    self.avatarImageView.setUnsplashImage(url)
                } else {
                    self.avatarImageView.image = UIImage(named: "placeholderAvatar")
                }
            }
        }
        
        viewModel.onError = { error in
            print("ERROR:", error)
        }
    }
    
    
    // MARK: - Layout UI
    private func layoutUI() {
        view.addSubview(avatarImageView)
        view.addSubview(editPhotoButton)
        view.addSubview(nameLabel)
        view.addSubview(listContainer)
        view.addSubview(versionLabel)
        
        [
            makeRow(icon: "questionmark.circle", title: "Help & Support", action: #selector(openSupport)),
            makeRow(icon: "hand.thumbsup", title: "Rate ZenWall", action: #selector(rateApp)),
            makeRow(icon: "lock", title: "Privacy Policy", action: #selector(openPrivacyPolicy)),
            makeRow(icon: "arrow.backward.square", title: "Sign Out",
                    isDestructive: true, action: #selector(signOutTapped))
        ]
            .forEach { listContainer.addArrangedSubview($0) }
        
        title = "Profile"
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        listContainer.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalToConstant: 128),
            
            editPhotoButton.widthAnchor.constraint(equalToConstant: 36),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 36),
            
            editPhotoButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            editPhotoButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            listContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            listContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            listContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            versionLabel.topAnchor.constraint(equalTo: listContainer.bottomAnchor, constant: 24),
            versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    // MARK: - Sign Out
    @objc private func signOutTapped() {
        showDestructiveAlert(
            title: "Signing out",
            message: "Are you sure?",
            destructiveTitle: "Yes"
        ) {
            self.viewModel.signOut()
            
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let delegate = scene.delegate as? SceneDelegate,
                  let window = delegate.window else { return }
            
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: {
                window.rootViewController = UINavigationController(rootViewController: LoginViewController())
                window.makeKeyAndVisible()
            })
        }
    }
    
    @objc private func openSupport() {
        let email = "support@zenwall.app"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func rateApp() {
        if let scene = view.window?.windowScene {
            AppStore.requestReview(in: scene)
        }
    }
    
    @objc private func openPrivacyPolicy() {
        guard let url = URL(string: "https://raw.githubusercontent.com/ceyhunml/zenwall-legal/refs/heads/main/privacy-policy.html") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func selectImage() {
        var actions: [(String, UIAlertAction.Style, () -> Void)] = []
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(("Camera", .default, { [weak self] in
                guard let self else { return }
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            }))
        }
        
        actions.append(("Gallery", .default, { [weak self] in
            guard let self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }))
        
        showActionSheet(
            title: "Profile Photo",
            message: "Choose a source",
            actions: actions
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage ??
                info[.originalImage] as? UIImage else { return }
        
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        guard let uid = UserDefaults.standard.string(forKey: "userId") else { return }
        
        AuthManager.shared.uploadProfileImage(uid: uid, imageData: data) { [weak self] url, error in
            guard let self else { return }
            
            if let error = error { print(error); return }
            guard let url else { return }
            
            AuthManager.shared.updateUserPhotoURL(uid: uid, photoURL: url) { error in
                if let error = error { print(error); return }
                
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
