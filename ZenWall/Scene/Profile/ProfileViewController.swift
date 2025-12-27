//
//  ProfileViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 09.12.25.
//

import UIKit
import StoreKit
import SafariServices
import PhotosUI

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
        lbl.textColor = UIColor(white: 0.7, alpha: 1)
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.showsVerticalScrollIndicator = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private let contentView = UIView()
    private let viewModel = ProfileViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Row Builder
    private func makeRow(icon: String, title: String, isDestructive: Bool = false, action: Selector? = nil) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor(red: 0.15, green: 0.17, blue: 0.16, alpha: 1)
        container.heightAnchor.constraint(equalToConstant: 52).isActive = true
        
        let iconContainer = UIView()
        iconContainer.backgroundColor = isDestructive ? UIColor.systemRed.withAlphaComponent(0.18) : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1).withAlphaComponent(0.18)
        
        iconContainer.layer.cornerRadius = 8
        iconContainer.clipsToBounds = true
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = isDestructive ? .systemRed : UIColor(red: 0.64, green: 0.73, blue: 0.66, alpha: 1)
        
        iconView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = isDestructive ? .systemRed : UIColor(red: 0.91, green: 0.88, blue: 0.84, alpha: 1)
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
    
    // MARK: - Bind ViewModel
    override func bindViewModel() {
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
        viewModel.loadUser()
    }
    
    // MARK: - Layout UI
    override func layoutUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            avatarImageView,
            editPhotoButton,
            nameLabel,
            listContainer,
            versionLabel
        ].forEach { contentView.addSubview($0) }
        
        [
            makeRow(icon: "questionmark.circle", title: "Help & Support", action: #selector(openSupport)),
            makeRow(icon: "hand.thumbsup", title: "Rate ZenWall", action: #selector(rateApp)),
            makeRow(icon: "lock", title: "Privacy Policy", action: #selector(openPrivacyPolicy)),
            makeRow(icon: "arrow.backward.square", title: "Sign Out",
                    isDestructive: true, action: #selector(signOutTapped))
        ].forEach { listContainer.addArrangedSubview($0) }
        
        title = "Profile"
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        editPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        listContainer.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 24),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 128),
            avatarImageView.heightAnchor.constraint(equalToConstant: 128),
            
            editPhotoButton.widthAnchor.constraint(equalToConstant: 36),
            editPhotoButton.heightAnchor.constraint(equalToConstant: 36),
            editPhotoButton.trailingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 4),
            editPhotoButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 4),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            listContainer.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 32),
            listContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            listContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            versionLabel.topAnchor.constraint(equalTo: listContainer.bottomAnchor, constant: 24),
            versionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
        setupAvatarTap()
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
    
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func openPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func selectImage() {
        var actions: [(String, UIAlertAction.Style, () -> Void)] = []
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(("Camera", .default, { [weak self] in
                self?.openCamera()
            }))
        }
        
        actions.append(("Gallery", .default, { [weak self] in
            self?.openPhotoLibrary()
        }))
        
        showActionSheet(
            title: "Profile Photo",
            message: "Choose a source",
            actions: actions
        )
    }
    
    @objc private func openSupport() {
        if let url = Constants.shared.supportURL {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func rateApp() {
        if let scene = view.window?.windowScene {
            AppStore.requestReview(in: scene)
        }
    }
    
    @objc private func openPrivacyPolicy() {
        guard let url = Constants.shared.privacyAndPolicyURL else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

extension ProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self,
                  let image = image as? UIImage,
                  let data = image.jpegData(compressionQuality: 0.8),
                  let uid = UserDefaults.standard.string(forKey: "userId")
            else { return }
            
            AuthManager.shared.uploadProfileImage(uid: uid, imageData: data) { url, error in
                if let error { print(error); return }
                guard let url else { return }
                
                AuthManager.shared.updateUserPhotoURL(uid: uid, photoURL: url) { error in
                    if let error { print(error); return }
                    
                    DispatchQueue.main.async {
                        self.avatarImageView.image = image
                    }
                }
            }
        }
    }
}
