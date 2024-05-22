//
//  DashboardViewController.swift
//  Lesson_19_05_24_Firebase
//
//  Created by Aykhan Hajiyev on 19.05.24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Kingfisher

final class DashboardViewController: UIViewController {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(logoutButton)
        view.addSubview(profileImageView)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(128)
        }
        
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        
        getUserProfileImageUrl()
    }
    
    @objc
    private func didTapLogoutButton() {
        self.dismiss(animated: true) {
            try? Auth.auth().signOut()
        }
        
    }
    
    private func getUserProfileImageUrl() {
        if let user = Auth.auth().currentUser {
            let userId = user.uid
            let db = Firestore.firestore()
            db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    self.showAlert(title: "fail", message: error.localizedDescription)
                    return
                }
                let documents = snapshot?.documents ?? []
                for document in documents {
                    if document["userId"] as? String == userId {
                        let profileImageUrl = document["profilePhotoUrl"] as? String ?? ""
                        let url = URL(string: profileImageUrl)
                        self.profileImageView.kf.setImage(with: url)
                    }
                }
            }
        }
    }
}
