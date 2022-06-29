
import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import ProgressHUD
import IQKeyboardManager

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewUI()
        loadMessages()
        
        
        
    }
    
    func viewUI(){
        title = C.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: C.cellNibName, bundle: nil), forCellReuseIdentifier: C.cellIdentifier)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        sendMessageButton.isEnabled = false
        
       
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
       messageSent()
    }
    
    
    @IBAction func logOutBtnPressed(_ sender: UIBarButtonItem) {
        
        logoutLogic()
    }
    
    
    func loadMessages() {
        
        db.collection(C.FStore.collectionName).order(by: C.FStore.dateField).addSnapshotListener { (querySnapshot,error) in
            
            self.messages = []
            
            if let e =  error {
                print("there was a problem retrieving messages from database \(e)")
            } else {
                if let snapshotDoc =  querySnapshot?.documents {
                    for doc in snapshotDoc {
                        let data = doc.data()
                        if let messageSender = data[C.FStore.senderField] as? String , let messageBody = data[C.FStore.bodyfield] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    func logoutLogic(){
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    func messageSent(){
        if let messageBody = messageTextfield.text ,   let messageSender = Auth.auth().currentUser?.email {
            db.collection(C.FStore.collectionName).addDocument(data: [
                
                C.FStore.senderField: messageSender,
                C.FStore.bodyfield: messageBody,
                C.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                    if let e = error {
                        print("there was a problem sending data to fire store \(e) ")
                    } else{
                        print("data was successfuly saved to firebase")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                        
                    }
                }
            
        }
    }
    
    
    
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: C.cellIdentifier ,for: indexPath) as! MessageCell
        
        cell.label.text = message.body
        
        if message.sender ==  Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden =  false
            cell.messageBubble.backgroundColor = UIColor(named: C.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: C.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden =  true
            cell.messageBubble.backgroundColor = UIColor(named: C.BrandColors.purple)
            cell.label.textColor = UIColor(named: C.BrandColors.lightPurple)
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}


