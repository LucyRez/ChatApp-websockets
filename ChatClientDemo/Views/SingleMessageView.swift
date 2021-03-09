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
    var date : Date
    
    init(text: String, date: Date) {
        self.text = text
        self.date = date
    }
    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Text(text)
                    .padding(10)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                
            }
            
            
            HStack{
                Spacer()
                Text(date, style: .time)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    
                
            }
                
        }.padding(10)
       
    }
}

struct SingleMessageView_Previews: PreviewProvider {
    static var previews: some View {
        SingleMessageView(text: "New message received", date: Date())
    }
}
