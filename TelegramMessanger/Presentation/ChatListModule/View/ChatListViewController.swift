import UIKit
import TdlibKit

class ChatListViewController: UIViewController {
    let chatTable: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.rowHeight =  70
        tableView.separatorColor = .gray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 0)
        
        return tableView
    }()
    let activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        return  activitiIndicator
    }()
    
    var presenter: ChatListPresenter!
    var chatDic: [ChatModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chats"
            
        view.addSubview(chatTable)
        view.addSubview(activityIndicator)
        setConstraints()
        activityIndicator.startAnimating()

        chatTable.dataSource = self
        chatTable.delegate = self
        
        presenter.getContact()

    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            chatTable.topAnchor.constraint(equalTo: view.topAnchor),
            chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: 40),
            activityIndicator.widthAnchor.constraint(equalToConstant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ChatListViewController: ChatListViewProtocol {
    func updateTableList(chatList: [ChatModel]) {
        self.chatDic = chatList
        DispatchQueue.main.async {
            self.chatTable.reloadData()
            self.activityIndicator.isHidden = true
        }
    }
}

extension ChatListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return chatDic?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath)  as! ChatTableViewCell
    
        guard let chatDic = chatDic else {
            cell.name.text = "nil"
            return cell
        }
        
        cell.name.text = chatDic[indexPath.row].title
        
        switch chatDic[indexPath.row].lastMessage?.content {
            
        case.messageText(let messageText):
            cell.lastMessage.text = messageText.text.text
        
        case .some(.messageAudio(_)):
            cell.lastMessage.text = "Audio"
            
        case .some(.messageDocument(_)):
            cell.lastMessage.text = "messageDocument"
            
        case .some(.messagePhoto(_)):
            cell.lastMessage.text = "messagePhoto"
            
        case .some(.messageSticker(_)):
            cell.lastMessage.text = "messageSticker"
            
        case .some(.messageVideo(_)):
            cell.lastMessage.text = "messageVideo"
            
        case .some(.messageExpiredVideo):
            cell.lastMessage.text = "messageExpiredVideo"
            
        case .some(.messageVoiceNote(_)):
            cell.lastMessage.text = "messageVoiceNote"
            
        case .some(.messageLocation(_)):
            cell.lastMessage.text = "messageLocation"
            
        case .some(.messageContact(_)):
            cell.lastMessage.text = "messageContact"
            
        case .some(.messageAnimatedEmoji(_)):
            cell.lastMessage.text = "messageAnimatedEmoji"
    
        case .some(.messagePoll(_)):
            cell.lastMessage.text = "messagePoll"
            
        case .some(.messageInvoice(_)):
            cell.lastMessage.text = "messageInvoice"
            
        case .some(.messageCall(_)):
            cell.lastMessage.text = "messageCall"
            
        default:
            cell.lastMessage.text = "other"
        }
        print ("****** photoInfoPath: \(chatDic[indexPath.row].photoInfoPath)")
        if let path  = chatDic[indexPath.row].photoInfoPath {
            print ("****** GetIPath: *****)")
            if let photo = UIImage(contentsOfFile: path) {
                print ("****** GetImagefromPath ****)")
                cell.contactImage.image = photo
            }
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("****** chat ID \(chatDic?[indexPath.row].chatId)")
        guard let chatDic = chatDic else { return }
        
        presenter.openChat(chat: chatDic[indexPath.row])
    }
}
