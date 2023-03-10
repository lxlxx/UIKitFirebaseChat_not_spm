//
//  Message.swift
//  FirebaseChat
//
//  Created by yu fai on 9/8/2016.
//  Copyright © 2016 YuFai. All rights reserved.
//

import Foundation
import FirebaseAuth


enum MessageTypes{
    case text
    case video
    case image
}

class SafeJSONObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let setValueSelectorString = "set\(key.uppercased().first!)\(String(key.dropFirst())):"
        let setValueSelector = Selector(setValueSelectorString)
        if responds(to: setValueSelector) {
            super.setValue(value, forKey: key)
        }
    }
}

class Message: SafeJSONObject {
    @objc var fromID: String?
    @objc var timestamp: NSNumber?
    @objc var toID: String?
    
    var messageType: MessageTypes { return .text }
    
    func chatPartnerID() -> String? {
        return fromID == Auth.auth().currentUser?.uid ? toID : fromID
    }
}

class imageMessage: Message {
    @objc var imageURL: String?
    @objc var imageHeight: NSNumber?
    @objc var imageWidth: NSNumber?
    
    override var messageType: MessageTypes { return .image }
}

class textMessage: Message {
    @objc var text: String?
    
    override var messageType: MessageTypes { return .text }
    
    convenience init(dict:[String: Any]) {
        self.init()
        fromID = dict["fromID"] as? String
        text = dict["text"] as? String
        timestamp = dict["timestamp"] as? NSNumber
        toID = dict["toID"] as? String

    }

}

class videoMessage: Message {
    var videoURL: String?
    
    override var messageType: MessageTypes { return .video }
}


class smartMessage2 {
    
    @objc var resultMessage: Message?
    
    @objc fileprivate var messageTypes2: Dictionary<String, Message> = [
        //example "chineseText" : MessageType.text(textMessage().textvalue = 20 ),
        "text" : textMessage(),
        "imageURL" : imageMessage(),
        "videoURL": videoMessage()
    ]
    
    fileprivate var messageTextContent: Dictionary<String, String> = [
        "imageURL" : "[ Image ]",
        "videoURL": "[ Video ]"
    ]
    
    func setMessage2(_ messageDictionary: [String: AnyObject]){
        for message in messageDictionary {
            if let type = messageTypes2[message.0]{
                type.setValuesForKeys(messageDictionary)
                resultMessage = type
            }
        }
    }
    
    func setMessageForNonTextMessage(_ messageDictionary: [String: AnyObject]){
        let tMessage = textMessage()
        tMessage.setValuesForKeys(messageDictionary)
        
        for message in messageDictionary {
            if let textContent = messageTextContent[message.0]{
                tMessage.text = textContent
            }
        }
        
        resultMessage = tMessage
    }
}


// let smartMessage = smartMessage()
// let message = smartMessage.setMessage(dictionary)
// self.messages.apppend(message)
// self.tableview.reloadData

//messageBrain -> message already setted

class smartMessage{
    
    var resultMessage: Message?
    
    fileprivate enum MessageType{
        //case text(() -> textMessage)
        case text(textMessage)
        case video(videoMessage)
        case image(imageMessage)
    }
    
    func setMessage(_ messageDictionary: [String: AnyObject]){
        for message in messageDictionary {
            if let type = messageTypes[message.0]{
                switch type {
                case .text (let message):
                    message.setValuesForKeys(messageDictionary)
                    //message().setValuesForKeysWithDictionary(messageDictionary)
                case .image(let message):
                    message.setValuesForKeys(messageDictionary)
                case .video(let message):
                    message.setValuesForKeys(messageDictionary)
                }
            }
        }
    }
    
    fileprivate var messageTypes: Dictionary<String, MessageType> = [
        //example "chineseText" : MessageType.text(textMessage().textvalue = 20 ),
        //"textMessage" : MessageType.text({let tmessage = textMessage(); return tmessage}),
        "textMessage" : MessageType.text(textMessage()),
        "imageURL" : MessageType.image(imageMessage()),
        "videoURL": MessageType.video(videoMessage())
    ]

}




//var type: Dictionary<MessageType, Message> = [
//    MessageType.image: imageMessage()
//]
//
//enum MessageType{
//    case text, video, image
//    
//    mutating func typeOfMessage(data: String) {
//        switch data {
//        case "text":
//            self = text
//        case "imageURL":
//            self = image
//        case "videoURL":
//            self = video
//        default:
//            break
//        }
//    }
//    
//}


