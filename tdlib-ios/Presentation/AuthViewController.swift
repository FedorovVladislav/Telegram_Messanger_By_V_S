//
//  AuthViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 09.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
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
        
        lable.text = "Fedorov V.S"
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboar))
        view.addGestureRecognizer(tap)
        
        phoneTextFiel.delegate  = self
        view.backgroundColor = .black

        view.addSubview(iconImageView)
        view.addSubview(nameProjectLale)
        view.addSubview(authtorLale)
        view.addSubview(phoneTextFiel)
        
        activateConstraints()
    }
    
    private func formatPhoneNumber(number: String) -> String {
            let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            let mask = "+X (XXX) XXX-XXXX"
            
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
            iconImageView.topAnchor.constraint(equalTo: view.topAnchor,constant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 150),
            iconImageView.widthAnchor.constraint(equalToConstant: 150),
            
            nameProjectLale.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 40),
            nameProjectLale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameProjectLale.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authtorLale.topAnchor.constraint(equalTo: nameProjectLale.bottomAnchor),
            authtorLale.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authtorLale.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
    
            phoneTextFiel.topAnchor.constraint(equalTo: authtorLale.bottomAnchor, constant: 80),
            phoneTextFiel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneTextFiel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            phoneTextFiel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
   @objc private func dismissKeyboar(){
        self.view.endEditing(true)
    }
}
extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
               let newString = (text as NSString).replacingCharacters(in: range, with: string)
               textField.text = formatPhoneNumber(number: newString)
               return false
    }
}

