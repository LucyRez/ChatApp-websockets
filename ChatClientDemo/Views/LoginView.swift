//
//  LoginView.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 11.03.2021.
//

import Foundation
import SwiftUI

/**
 Экран для входа в приложение.
 */
struct LoginView : View {
    
    @StateObject var socketManager : SocketIOManager = SocketIOManager() // Создаём сокет-менеджер.
    
    var body: some View{
        NavigationView{
            VStack{
                // Не переходим в чат, пока не подтверждено имя пользователя.
                NavigationLink(
                    destination: ChatScreen(socketManager: socketManager),
                    isActive: $socketManager.notJustOpened){EmptyView()}
                
                Text("Enter the Local Server Chat")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 30)
                
                TextField("Write your nickname here...", text: $socketManager.nickname)
                    .font(.system(size: 30))
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .padding(20)
                
                // Кнопка для входа в чат (не активна, когда ничего не ввели в строке с именем).
                Button(action: {
                    socketManager.notJustOpened.toggle()
                },
                label: {
                    Text("Start Chatting")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                }).disabled(socketManager.nickname.isEmpty)
                
            }
        }
    }
}
