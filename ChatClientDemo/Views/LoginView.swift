//
//  LoginView.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 11.03.2021.
//

import Foundation
import SwiftUI

struct LoginView : View {
    
    @StateObject var socketManager : SocketIOManager = SocketIOManager()
    //@State var temp : String
    
    var body: some View{
        NavigationView{
        VStack{
            NavigationLink(
                destination: ChatScreen(socketManager: socketManager),
                isActive: $socketManager.justOpened){EmptyView()}
            
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
            
            Button(action: {
                    socketManager.justOpened.toggle()
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


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(temp: "hdj")
//    }
//}
