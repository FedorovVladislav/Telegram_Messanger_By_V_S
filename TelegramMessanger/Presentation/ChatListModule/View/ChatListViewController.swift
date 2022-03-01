import UIKit
import TdlibKit

class ChatListViewController: UIViewController {
    let chatTable: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.rowHeight =  60
        
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
        presenter.getContact()
   
        chatTable.dataSource = self
        chatTable.delegate = self
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
            cell.LastMessage.text = messageText.text.text
        
        case .some(.messageAudio(_)):
            cell.LastMessage.text = "Audio"
            
        case .some(.messageDocument(_)):
            cell.LastMessage.text = "messageDocument"
            
        case .some(.messagePhoto(_)):
            cell.LastMessage.text = "messagePhoto"
            
        case .some(.messageSticker(_)):
            cell.LastMessage.text = "messageSticker"
            
        case .some(.messageVideo(_)):
            cell.LastMessage.text = "messageVideo"
            
        case .some(.messageExpiredVideo):
            cell.LastMessage.text = "messageExpiredVideo"
            
        case .some(.messageVoiceNote(_)):
            cell.LastMessage.text = "messageVoiceNote"
            
        case .some(.messageLocation(_)):
            cell.LastMessage.text = "messageLocation"
            
        case .some(.messageContact(_)):
            cell.LastMessage.text = "messageContact"
            
        case .some(.messageAnimatedEmoji(_)):
            cell.LastMessage.text = "messageAnimatedEmoji"
    
        case .some(.messagePoll(_)):
            cell.LastMessage.text = "messagePoll"
            
        case .some(.messageInvoice(_)):
            cell.LastMessage.text = "messageInvoice"
            
        case .some(.messageCall(_)):
            cell.LastMessage.text = "messageCall"
            
        default:
            cell.LastMessage.text = "other"
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("****** chat ID \(chatDic?[indexPath.row].chatId)")
        guard let chatDic = chatDic else { return }
        
        presenter.openChat(chat: chatDic[indexPath.row])
    }
}
