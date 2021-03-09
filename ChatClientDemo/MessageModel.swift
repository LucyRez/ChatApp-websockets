//
//  MessageModel.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 11.02.2021.
//

import Foundation

struct SubmittedMessage : Encodable{
    let message : String
}

struct ReceivedMessage : Decodable{
    let date : Date
    let id = UUID()
    let message : String
}


