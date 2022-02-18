//
//  ChatTableViewCell.swift
//  tdlib-ios
//
//  Created by Елизавета Федорова on 17.02.2022.
//  Copyright © 2022 Anton Glezman. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCell"
    
    
    var name: UILabel =  {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "Name"
        lable.textColor  = .white
        return lable
    }()
    let LastMessage: UILabel =  {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = "LasMess"
        lable.textColor = .darkGray
        return lable
    }()
//    let containerView:  UIView  =  {
//       let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints  =   false
//        view.clipsToBounds  =  true
//        return  view
//    }()
//
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(LastMessage)
        contentView.backgroundColor = .black
      
        NSLayoutConstraint.activate([
        
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            
            LastMessage.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            LastMessage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       // name.frame = CGRect(x: 5, y: 5, width: 100, height: 20)
    }

}
