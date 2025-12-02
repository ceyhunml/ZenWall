//
//  PasswordViewController.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 02.12.25.
//

import UIKit

class PasswordViewController: UIViewController {
    
    let viewModel: PasswordViewModel
    let builder: UserBuilder
    
    init(viewModel: PasswordViewModel, builder: UserBuilder) {
        self.viewModel = viewModel
        self.builder = builder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private lazy var passwordTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Create your password"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Must be at least 6 characters long."
        lbl.textColor = UIColor(white: 1, alpha: 0.65)
        lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
    }()
    
    private lazy var fieldHeaderLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Password"
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return lbl
    }()
    
    private lazy var passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your password"
        tf.textColor = .white
        tf.backgroundColor = UIColor(red: 0.11, green: 0.16, blue: 0.15, alpha: 1)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.autocapitalizationType = .words
        tf.autocorrectionType = .no
        tf.isSecureTextEntry = true
        tf.font = UIFont.systemFont(ofSize: 17)
        return tf
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.backgroundColor = UIColor(red: 0.07, green: 0.83, blue: 0.32, alpha: 1)
        btn.tintColor = UIColor(red: 0.07, green: 0.13, blue: 0.10, alpha: 1)
        btn.layer.cornerRadius = 28
        btn.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        setupConstraints()
        setupGradientBackground()
    }
    
    // MARK: - Setup UI
    private func setupGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.06, green: 0.09, blue: 0.08, alpha: 1).cgColor,
            UIColor(red: 0.09, green: 0.12, blue: 0.10, alpha: 1).cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.frame = view.bounds
        
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupConstraints() {
        title = "Step 3 of 3"
        [passwordTitleLabel, subtitleLabel,
         fieldHeaderLabel, passwordField, nextButton]
            .forEach { sub in
                sub.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(sub)
            }
        
        NSLayoutConstraint.activate([
            
            passwordTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            passwordTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            subtitleLabel.topAnchor.constraint(equalTo: passwordTitleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: passwordTitleLabel.leadingAnchor),
            
            fieldHeaderLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 32),
            fieldHeaderLabel.leadingAnchor.constraint(equalTo: passwordTitleLabel.leadingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: fieldHeaderLabel.bottomAnchor, constant: 6),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            passwordField.heightAnchor.constraint(equalToConstant: 56),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func nextAction() {
        guard let password = passwordField.text, !password.isEmpty else {
            alertFor(title: "Oops!", message: "Please enter your password.")
            return
        }
        
        guard password.count >= 6 else {
            alertFor(title: "Invalid Password", message: "Password must be at least 6 characters.")
            return
        }
        
        builder.setPassword(password: password)
        
        builder.build { [weak self] success, error, email, password in
            guard let self else { return }
            
            if let error {
                self.alertFor(title: "Error", message: error)
                return
            }
            
            let alert = UIAlertController(
                title: "Done!",
                message: "Your account has been created successfully!",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in

                self.navigationController?.popToRootViewController(animated: true)

                if let loginVC = self.navigationController?.viewControllers.first as? LoginViewController {

                    loginVC.viewModel.prefillEmail = email
                    loginVC.viewModel.prefillPassword = password

                    loginVC.viewWillAppear(true)
                }
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }
    }
}
