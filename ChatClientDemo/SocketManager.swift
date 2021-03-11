//
//  SocketManager.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 07.02.2021.
//

import Foundation
import SocketIO

enum DateError: String, Error {
    case invalidDate
}

/**
 This class implements all the interaction with server by using websokets.
 
 - returns: socket io manager
 
 # Notes: #
 1. Work in progress
 2. Need to add sending messages back from the server to clients
 3. Need to add functionality for different users
 
 */
final class SocketIOManager: ObservableObject{
    
    // manager listens to certain porton localhost
    private var manager = SocketManager(socketURL: URL(string: "ws://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil // here lies socket for certain client
    
    
    /// Function initializes socket and sets all the events
    func setSocket(){
        self.socket = manager.defaultSocket
        socket?.connect()
        setSocketEvents()
    }
    
    /// Function sets all the events
    func setSocketEvents(){
        socket?.on(clientEvent: .connect){ (data,ack) in
            print("Connected")
            self.socket?.emit("Server Event", "Hi NODEJS server!")
        }
        
    }
    
    /// Function implements disconnections from the server
    func disconnect(){
        socket?.disconnect()
    }
    
    /// Function sends a message to the server by triggering chatMessage event
    func sendMessage(text: String, user: String){
        let message = SubmittedMessage(message: text, nickname: user )
        
        guard let json = try? JSONEncoder().encode(message),
              let jsonString = String(data: json, encoding: .utf8)
        else{
            return
        }
        socket?.emit("chatMessage", String(jsonString))
    }
    
    func getMessages(completionHandler: @escaping ([ReceivedMessage]) -> Void){
        var messages : [ReceivedMessage] = []
        
        socket?.on("messageHistory"){data, ack in
            
               // var message : ReceivedMessage?
            
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                    
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .iso8601)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)
                        
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date().addingTimeInterval(86400) // TODO throw something
                    })
                    
                    messages = try! decoder.decode([ReceivedMessage].self, from: jsonData)
                    //messages.append(message!)
                }
            }
            
            completionHandler(messages)
        }
    }
    
    func getLastMessage(completionHandler: @escaping (ReceivedMessage) -> Void){
        var message : ReceivedMessage?
        
        socket?.on("newMessage"){data, ack in
            
            if let jsonData  = try? JSONSerialization.data(withJSONObject: data.first!, options: []){
                do{
                    let decoder = JSONDecoder()
                    
                    let formatter = DateFormatter()
                    formatter.calendar = Calendar(identifier: .iso8601)
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    
                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                        let container = try decoder.singleValueContainer()
                        let dateStr = try container.decode(String.self)
                        
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
                        if let date = formatter.date(from: dateStr) {
                            return date
                        }
                        return Date().addingTimeInterval(86400) // TODO throw something
                    })
                    
                    message = try! decoder.decode(ReceivedMessage.self, from: jsonData)
                }
            }
            
            completionHandler(message!)
        }
    }
}

