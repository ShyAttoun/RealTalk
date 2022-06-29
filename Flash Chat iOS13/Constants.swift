//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by shy attoun on 12/05/2022.

//

struct C {
    
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let appName = "RealTalk"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyfield = "body"
        static let dateField = "date"
    }
}
