//
//  AppError.swift
//  SPPokeMaster
//
//  Created by 宋璞 on 2023/4/14.
//

import Foundation


enum AppError: Error, Identifiable {
    
    var id: String { localizedDescription }
    
    case passwordWrong
    
    case networkingFailed(Error)
    
    case requirestLogin
    
    case loadAbilityError
}


extension AppError: LocalizedError {
    var localizedDescripition: String {
        switch self {
        case .passwordWrong: return "密码错误"
        case .networkingFailed(let error): return error.localizedDescription
        case .requirestLogin: return "未登录"
        case .loadAbilityError: return "Ability 加载失败"
        }
    }
    
}
