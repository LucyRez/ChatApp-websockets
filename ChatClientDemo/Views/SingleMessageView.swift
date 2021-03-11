//
//  SingleMessageView.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 09.03.2021.
//

import Foundation
import SwiftUI

struct SingleMessageView : View{
    
    var text : String
    var nickname : String
    var date : Date
    var isCurrentUser : Bool
    
    init(text: String, nickname: String, date: Date, isCurrentUser: Bool) {
        self.text = text
        self.date = date
        self.isCurrentUser = isCurrentUser
        self.nickname = nickname
    }
    
    var body: some View{
        VStack{
            HStack{
                if(isCurrentUser){
                    Spacer()
                }
                
                
                VStack{
                    if(!isCurrentUser){
                        HStack{
                            Text(nickname)
                                .font(.system(size: 13))
                                .bold()
                                .offset(y:5)
                            Spacer()
                            
                        }
                    }
                    
                    HStack{
                        Text(text)
                            .padding(10)
                            .foregroundColor(isCurrentUser ? Color.white : Color.black)
                            .background(isCurrentUser ? Color.blue : Color.gray)
                            .cornerRadius(10)
                            .lineLimit(nil)
                        
                        if(!isCurrentUser){Spacer()}
                    }
                    
                    
                }.fixedSize(horizontal: false, vertical: true)
                
                
                if(!isCurrentUser){
                    Spacer()
                }
            }
            
            
            HStack{
                if(!isCurrentUser){
                    Text(date, style: .time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Spacer()
                    
                }else{
                    Spacer()
                    Text(date, style: .time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                
                
            }
            
        }.padding(10)
        
    }
}

struct SingleMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SingleMessageView(text: "New message is here but you cant respond", nickname: "Some nickname", date: Date(), isCurrentUser: true)
    }
}
