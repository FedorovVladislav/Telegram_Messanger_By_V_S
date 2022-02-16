//
//  AuthViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 09.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import TdlibKit

class AuthNumberViewController: UIViewController {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        let iconImage = UIImage(named: "Telegram_Messenger")
        imageView.image = iconImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    let authtorLale: UILabel = {
        var lable = UILabel()
        
        lable.text = "by Fedorov V.S"
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15, weight: .light)
        lable.textColor = .systemGray4

        return  lable
    }()
    let nameProjectLale: UILabel = {
        var lable = UILabel()
        
        lable.text = "Telegram"
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 40, weight: .light)
        lable.textColor = .systemGray4
        
        return  lable
    }()
    let phoneTextFiel: UITextField = {
        let textField = UITextField()
    
        textField.placeholder = "+7 (xxx) xxx xx xx"
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.contentVerticalAlignment = .bottom
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        button.backgroundColor = .darkGray

        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        
        return button
    }()
    
    var presenter: AuthNumberPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Скрытие клавиатуры
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboar))
        view.addGestureRecognizer(tap)
        
        phoneTextFiel.delegate  = self
        view.backgroundColor = .black

        view.addSubview(iconImageView)
        view.addSubview(nameProjectLale)
        view.addSubview(authtorLale)
        view.addSubview(phoneTextFiel)
        view.addSubview(signInButton)
        
        activateConstraints()
    }
    
    private func formatPhoneNumber(number: String) -> String {
            let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "+X (XXX) XXX-XX-XX"
            
            var result = ""
            var index = cleanPhoneNumber.startIndex
            for ch in mask where index < cleanPhoneNumber.endIndex {
                if ch == "X" {
                    result.append(cleanPhoneNumber[index])
                    index = cleanPhoneNumber.index(after: index)
                } else {
                    result.append(ch)
                }
            }
            return result
        }
    
    private func activateConstraints(){
        NSLayoutConstraint.activate([
            
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: nameProjectLale.topAnchor,constant: -20),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            
            nameProjectLale.bottomAnchor.constraint(equalTo: authtorLale.topAnchor),
            nameProjectLale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameProjectLale.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authtorLale.bottomAnchor.constraint(equalTo: phoneTextFiel.topAnchor,constant: -40),
            authtorLale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authtorLale.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
    
            phoneTextFiel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneTextFiel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneTextFiel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            phoneTextFiel.heightAnchor.constraint(equalToConstant: 40),
            
            signInButton.topAnchor.constraint(equalTo: phoneTextFiel.bottomAnchor, constant: 80),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func dismissKeyboar(){
        self.view.endEditing(true)
    }
    
    @objc private func signIn() {
        let phoneNumber = removeNumberFormat(number: phoneTextFiel.text!)

        presenter.sendCode(number: phoneNumber)
        print("ButtonWork")

        
    }
    
    private func removeNumberFormat(number: String) -> String {
            let digits = CharacterSet.decimalDigits
            var text = ""
            for char in number.unicodeScalars {
                if digits.contains(char) {
                    text.append(char.description)
                }
            }
            return text
        }
}

extension AuthNumberViewController: AuthNumberViewProtocol {
    
}

extension AuthNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
               let newString = (text as NSString).replacingCharacters(in: range, with: string)
               textField.text = formatPhoneNumber(number: newString)
               return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count == 18 {
            signInButton.isEnabled = true
            signInButton.backgroundColor = .systemBlue
            dismissKeyboar()
            
        } else {
            signInButton.isEnabled = false
            signInButton.backgroundColor = .darkGray
        }
    }
}

