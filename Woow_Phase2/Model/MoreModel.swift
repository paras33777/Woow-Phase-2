//
//  MoreModel.swift
//  Woow_Phase2
//
//  Created by Rahul Chopra on 08/12/21.
//

import Foundation
import UIKit

enum MoreEnum {
    case accountSetting
    case language
    case help
    case terms
    case privacy
    case logout
    case myPlans
    case kids
}

struct MoreSectionModel {
    let name: String
    let item: [MoreItemModel]
    
    struct MoreItemModel {
        let name: String
        let image: String
        let action: MoreEnum
    }
}


enum AccountSettingEnum {
    case changePwd
    case videoQuality
    case downloadSetting
}

struct AccountSettingModel {
    let name: String
    let image: String
    let action: AccountSettingEnum
}
