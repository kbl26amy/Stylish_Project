//
//  APIProtocol.swift
//  STYLISH
//
//  Created by 楊雅涵 on 2019/7/11.
//  Copyright © 2019 AmyYang. All rights reserved.
//
import UIKit
import Foundation

struct DataProduct: Codable {
    var data: [Product]
}

struct Product: Codable {
    var title: String
    var products: [ProductObject]
    }

struct FemaleObject: Codable {
    var paging: Int?
    var data: [ProductObject]
}

struct ProductObject: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Int
    let texture: String
    let wash: String
    let place: String
    let note: String
    let story: String
    let colors: [ColorObject]
    let sizes: [String]
    var variants: [VariantObject]
    let mainImage: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case texture
        case wash
        case place
        case note
        case story
        case colors
        case sizes
        case variants
        case mainImage = "main_image"
        case images

    }
}

struct ColorObject: Codable {
    var name: String
    var code: String
}

struct VariantObject: Codable {
    var colorCode: String
    var size: String
    var stock: Int
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size
        case stock
    }
}

struct FBData: Codable {
    var data: User
}

struct User: Codable {
    var accessToken: String
    var accessExpired: Int
    var user: UserObject
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessExpired = "access_expired"
        case user
    }
}

struct UserObject: Codable {
    var id: Int
    var provider: String
    var name: String
    var email: String
    var picture: String
}

enum ProductEndPoint: String {
    case womenEendPoint = "/women"
    case menEndPoint = "/men"
    case accesoriesEndPoint = "/accessories"
}
struct List: Codable {
    var id: String
    var name: String
    var price: Int
    var color: ColorObject
    var size: String
    var qtn: Int
}

struct Recipient:Codable {
    var name: String
    var phone: String
    var email: String
    var address: String
    var time: String
}

struct Order:Codable {
    var shipping: String
    var payment: String
    var subtotal: Int
    var freight: Int
    var total: Int
    var recipient: Recipient
    var list: [List]
}

struct ServerCheckOut: Codable {
    var prime: String
    var order: Order
}

