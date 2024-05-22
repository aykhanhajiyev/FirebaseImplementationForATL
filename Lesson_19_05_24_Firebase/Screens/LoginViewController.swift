//
//  ViewController.swift
//  Lesson_19_05_24_Firebase
//
//  Created by Aykhan Hajiyev on 19.05.24.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {

    private let fieldsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let emailTextField: InsetTextField = {
        let tf = InsetTextField()
        tf.placeholder = "Enter your email"
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    private let passwordTextField: InsetTextField = {
        let tf = InsetTextField()
        tf.placeholder = "Enter your password"
        tf.isSecureTextEntry = true
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(fieldsStackView)
        
        fieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        [
            emailTextField,
            passwordTextField,
            signInButton,
            signUpButton
        ].forEach(fieldsStackView.addArrangedSubview)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        fieldsStackView.setCustomSpacing(32, after: passwordTextField)
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("AUTH AUTH", Auth.auth().currentUser)
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                let vc = DashboardViewController()
                self.present(vc, animated: true)
            }
        }
    }
    
    @objc
    private func didTapSignInButton() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Validation failed", message: "Email can not be empty")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Validation failed", message: "Password can not be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            if let error = error as? NSError {
                switch AuthErrorCode.Code(rawValue: error.code) {
                default:
                    self?.showAlert(title: "Something went wrong", message: error.localizedDescription)
                    return
                }
                
            }
            // success case
            print("User login successfully")
            let newUserInfo = Auth.auth().currentUser
            print(newUserInfo?.email)
            print(newUserInfo?.uid)
            let vc = DashboardViewController()
            self?.present(vc, animated: true)
        }
    }
    
    @objc
    private func didTapSignUpButton() {
        let vc = RegisterViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

