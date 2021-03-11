//
//  MessageModel.swift
//  ChatClientDemo
//
//  Created by Ludmila Rezunic on 11.02.2021.
//

import Foundation

struct SubmittedMessage : Encodable{
    let message : String
    let nickname : String
}

struct ReceivedMessage : Decodable, Equatable{
    let date : Date
    let id = UUID()
    let nickname : String
    let message : String
}


