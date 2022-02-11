//
//  AuthCodeViewController.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 10.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit
import TdlibKit

class AuthCodeViewController: UIViewController {
    
    let textTextReplaySMS:UILabel =  {
       let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont.systemFont(ofSize: 20, weight: .light)
        lable.textColor = .white
        lable.text = "Повторная отправка смс \n через 20 секунд"
        lable.lineBreakMode = .byWordWrapping
        lable.numberOfLines = 0
        lable.textAlignment = .center
        return lable
    }()
    let codeTextFueld: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Code"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .darkGray
        textField.textColor = .white
        textField.borderStyle = .roundedRect
        return textField
    }()
    let replySmsButton: UIButton  = {
        let button  = UIButton()
        
        button.setTitle("Reply SMS", for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(replySMS), for: .touchUpInside)
        button.isHidden = true
        
        return button
    }()
    var timer : Timer?
    var count = 20
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.title = "Insert Code"
        view.backgroundColor = .black
        
        view.addSubview(textTextReplaySMS)
        view.addSubview(codeTextFueld)
        view.addSubview(replySmsButton)
        
        activateConstraints()
        startTimer()
        
        // send sms
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            
            textTextReplaySMS.bottomAnchor.constraint(equalTo: codeTextFueld.topAnchor, constant: -150),
            textTextReplaySMS.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textTextReplaySMS.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            
            codeTextFueld.widthAnchor.constraint(equalToConstant: 200),
            codeTextFueld.heightAnchor.constraint(equalToConstant: 40),
            codeTextFueld.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            codeTextFueld.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            replySmsButton.widthAnchor.constraint(equalToConstant: 200),
            replySmsButton.heightAnchor.constraint(equalToConstant: 40),
            replySmsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 150),
            replySmsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func startTimer() {
        count = 20
        
        timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.count <  1 {
                timer.invalidate()
                DispatchQueue.main.async {
                    self.replySmsButton.isHidden = false
                    self.textTextReplaySMS.text = "Повторная отправка смс"
                }
            } else {
                self.count -= 1
                DispatchQueue.main.async {
                    self.textTextReplaySMS.text = "Повторная отправка смс \n через \(self.count) секунд "
                }
            }
        }
    }
    
    @objc private func replySMS() {
        print("Button Work ")
        replySmsButton.isHidden = true
        textTextReplaySMS.isHidden  = false
        startTimer()
    }
}
