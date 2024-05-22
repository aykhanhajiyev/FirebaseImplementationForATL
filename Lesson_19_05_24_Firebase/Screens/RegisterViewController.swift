//
//  RegisterViewController.swift
//  Lesson_19_05_24_Firebase
//
//  Created by Aykhan Hajiyev on 19.05.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

final class RegisterViewController: UIViewController, UINavigationControllerDelegate {
    
    private var imagePicker = UIImagePickerController()
    private var selectedImage: UIImage? = nil
    
    private let fieldsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultPhoto")
        iv.layer.cornerRadius = 60
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameTextField: InsetTextField = {
        let tf = InsetTextField()
        tf.placeholder = "Enter your name"
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        return tf
    }()
    
    private let surnameTextField: InsetTextField = {
        let tf = InsetTextField()
        tf.placeholder = "Enter your surname"
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 10
        return tf
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
    
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(profileImageView)
        view.addSubview(fieldsStackView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        fieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        [
            nameTextField,
            surnameTextField,
            emailTextField,
            passwordTextField,
            signUpButton
        ].forEach(fieldsStackView.addArrangedSubview)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        
        fieldsStackView.setCustomSpacing(32, after: passwordTextField)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
        let tapGestureImageView = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureImageView)
        
        imagePicker.delegate = self
    }
    
    @objc
    private func didTapImageView() {
        let alertVC = UIAlertController(title: "Select profile image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Open camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true)
        }
        
        let galleryAction = UIAlertAction(title: "Open gallery", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(galleryAction)
        
        if let _ = selectedImage {
            let deleteAction = UIAlertAction(title: "Delete image", style: .destructive) { _ in
                self.profileImageView.image = UIImage(named: "defaultPhoto")
                self.profileImageView.layer.borderColor = UIColor.lightGray.cgColor
                self.selectedImage = nil
            }
            alertVC.addAction(deleteAction)
        }
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true)
    }
    
    @objc
    private func didTapSignUpButton() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(title: "Validation failed", message: "Name can not be empty")
            return
        }
        guard let surname = surnameTextField.text, !surname.isEmpty else {
            showAlert(title: "Validation failed", message: "Surname can not be empty")
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(title: "Validation failed", message: "Email can not be empty")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Validation failed", message: "Password can not be empty")
            return
        }
        
        guard let image = selectedImage else {
            showAlert(title: "Validation failed", message: "Image can not be empty")
            profileImageView.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        // Image upload
        let storageRef = Storage.storage().reference()
        
        let profileImagesRef = storageRef.child("/profilePhotos/" + UUID().uuidString + ".jpg")
        
        let selectedImageData = selectedImage?.jpegData(compressionQuality: 0.5) ?? Data()
        profileImagesRef.putData(selectedImageData) { metaData, error in
            if let error = error {
                self.showAlert(title: "Upload failed", message: error.localizedDescription)
                return
            }
            // Register
            profileImagesRef.downloadURL { url, error in
                self.registerUser(name: name, surname: surname, email: email, password: password, profileImageUrl: url?.absoluteString ?? "")
            }
        }
        
    }
    
    private func registerUser(name: String, surname: String, email: String, password: String, profileImageUrl: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] signInResult, signInError in
            if let error = signInError {
                self?.showAlert(title: "Something went wrong", message: error.localizedDescription)
                return
            }
            print("User sign up already")
            let newUserInfo = Auth.auth().currentUser
            
            if let userId = newUserInfo?.uid {
                let db = Firestore.firestore()
                db.collection("users").addDocument(data: ["name": name, "surname": surname, "userId": userId, "profilePhotoUrl": profileImageUrl])
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            let originalImage = info[.originalImage] as? UIImage
            self.profileImageView.image = originalImage
            self.selectedImage = originalImage
            self.profileImageView.layer.borderColor = UIColor.green.cgColor
        }
    }
}
