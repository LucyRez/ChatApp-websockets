//
//  SocketManager.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 07.02.2021.
//

import Foundation
import SocketIO

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
    @Published var messages = [String]() // array of messages
    
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
    func sendMessage(text: String){
        socket?.emit("chatMessage", text);
    }
    
    func getMessages(completionHandler: @escaping ([String: Any]) -> Void){
        socket?.on("newMessage"){data, _ in
            var messageDictionary: [String:Any] = [:]
            
            messageDictionary["message"] = data[0] as! String
            messageDictionary["time"] = data[1] as! String
            
            completionHandler(messageDictionary)
        }
    }
}
