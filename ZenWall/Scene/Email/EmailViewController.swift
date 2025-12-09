//
//  EmailViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 27.11.25.
//

import UIKit

class EmailViewController: BaseViewController {

    // MARK: - UI Elements
    private lazy var emailTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "What's your email?"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "For account recovery and updates on your favorite wallpapers."
        lbl.numberOfLines = 0
        lbl.textColor = UIColor(white: 1, alpha: 0.65)
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    private lazy var fieldHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Email address"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    
    private lazy var emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your email"
        tf.textColor = .white
        tf.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.15, alpha: 1)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Next", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1)
        btn.tintColor = UIColor(red: 0.07, green: 0.13, blue: 0.10, alpha: 1)
        btn.layer.cornerRadius = 28
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()
    
    let builder = UserBuilder()
    let viewModel: EmailViewModel
    
    init(viewModel: EmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        setupConstraints()        
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup UI
    private func setupConstraints() {
        title = "Step 1 of 3"
        [emailTitleLabel, subtitleLabel,
         fieldHeaderLabel, emailField, nextButton]
            .forEach { sub in
                sub.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(sub)
            }
        
        NSLayoutConstraint.activate([
            
            emailTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            emailTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: emailTitleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -6),
            
            fieldHeaderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            fieldHeaderLabel.leadingAnchor.constraint(equalTo: emailTitleLabel.leadingAnchor),
            
            emailField.topAnchor.constraint(equalTo: fieldHeaderLabel.bottomAnchor, constant: 6),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            emailField.heightAnchor.constraint(equalToConstant: 56),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextAction() {
        guard let email = emailField.text, !email.isEmpty else {
            alertFor(title: "Oops!", message: "Please enter your email.")
            return
        }
        
        guard email.isValidEmail else {
            alertFor(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        viewModel.onEmailCheck = { [weak self] exists, error in
            guard let self else { return }
            
            if let error {
                self.alertFor(title: "Error", message: error)
                return
            }
            
            if exists {
                self.alertFor(title: "Oops!", message: "This email is already registered.")
            } else {
                viewModel.coordinator.showFullname(email: email)
            }
        }
        viewModel.checkEmail(email)
    }
}
