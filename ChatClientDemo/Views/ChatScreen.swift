//
//  ChatScreen.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 07.02.2021.
//

import SwiftUI

/**
 Screen of the chat (one conversation)
 
 - returns: a view of the chat
 
 # Notes: #
 1. Work in progress
 
 */
struct ChatScreen: View{
    @State private var message = "" // message from text field
    @StateObject private var manager = SocketIOManager() // socket io manager
    // Array of received messages.
    @State private var messages: [ReceivedMessage] = []
    
    /// This function connects chat with socket at the start of application
    func onAppear(){
        manager.setSocket()
    }
    
    /// This function disconnects app from server after closing
    func onDisappear(){
        manager.disconnect()
    }
    
    /// Function initializes sending of message to server
    private func onSend(){
        if !message.isEmpty {
            manager.sendMessage(text: message)
            message = ""
        }
    }
    
    func startGettingMessages(){
        manager.getMessages(completionHandler: {data in
            messages.append(data)
        })
    }
    
    var body: some View {
        VStack{
            // Here are going to be messages
            ScrollView{
                
                
                ForEach(messages, id: \.id){mes in
                    HStack{
                        SingleMessageView(text: mes.message, date: mes.date)
                        
                    }
                    
                }
            }
            
            // HStack keeps UI elements from the bottom of the screen (text field and button)
            HStack{
                
                TextField("Message", text: $message)
                    .padding(10)
                    .background(Color.secondary.opacity(0.2))
                    .cornerRadius(5.0)
                
                Button(action: onSend) {
                    Image(systemName: "paperplane")
                        .font(.system(size: 25))
                }
                .padding(5)
                .disabled(message.isEmpty)
            }
            .padding()
        }
        .onAppear(perform: onAppear)
        .onAppear(perform: startGettingMessages)
        .onDisappear(perform: onDisappear)
    }
}

struct ChatScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChatScreen()
    }
}


