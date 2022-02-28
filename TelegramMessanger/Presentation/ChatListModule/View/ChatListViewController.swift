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
    let reloadButton: UIBarButtonItem = {
        let image = UIImage(systemName: "repeat")
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(getDat))
        
        return barButtonItem
    }()
   
    var presenter: ChatListPresenter!

   // var chatData: [UpdateNewChat]?
    var chatDic: [ChatModel]?
   // var chatPos: [ChatPositionlist]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chat List"
        
        navigationItem.rightBarButtonItem = reloadButton
        
        view.addSubview(chatTable)
        
        presenter.networkLayer.getContact()
        
        chatTable.dataSource = self
        chatTable.delegate = self
        
        NSLayoutConstraint.activate([
            chatTable.topAnchor.constraint(equalTo: view.topAnchor),
            chatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        /// guard let nv = presenter.router.current.children.first  else { return }
      //  print ("*****  children vc: \(nv.children)")
    }
    
    func getChatList() {
        
    }
    
    @objc func getDat() {
        print("BBarButtonWork")
        presenter.getContact()
    }
}

extension ChatListViewController: ChatListViewProtocol {
    func updateTableList(chatList: [ChatModel]) {
        self.chatDic = chatList
        DispatchQueue.main.async {
            self.chatTable.reloadData()
        }
    }
}

extension ChatListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        return chatDic?.count ?? 10
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
        guard let lastMess = chatDic[indexPath.row].lastMessage else { return }
        
        presenter.openChat(chatID: chatDic[indexPath.row].chatId, lastMess: lastMess)
    }
}




