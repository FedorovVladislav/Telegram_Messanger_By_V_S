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
    var contactImage: UIImageView = {
        let imageView  = UIImageView()
        let image = UIImage(systemName: "person.2.fill")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(LastMessage)
        contentView.addSubview(contactImage)
        contentView.backgroundColor = .black
      
        NSLayoutConstraint.activate([
            
            contactImage.heightAnchor.constraint(equalToConstant: 40),
            contactImage.widthAnchor.constraint(equalToConstant: 40),
            contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            name.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 5),
            
            LastMessage.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5),
            LastMessage.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 5)
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
