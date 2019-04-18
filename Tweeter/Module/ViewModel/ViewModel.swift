//
//  ViewModel.swift
//  Tweeter
//
//  Created by HUYNH Hoc Luan on 4/17/19.
//  Copyright © 2019 Luan Huynh. All rights reserved.
//

import RxSwift
import RxCocoa
import Toast_Swift

struct ViewModel {
    
    // MARK: Properties
    var listMessage: [String]? = []
    var listData: Variable<Array<SectionModel<String, String>>>? = Variable([])
    
    mutating func initDataFromListMessage() -> Void {
        self.listData?.value.removeAll()
        if var listData =  self.listData?.value, let listMessage = self.listMessage, listMessage.count > 0 {
            let sectionModel = SectionModel(model: "", items: listMessage)
            listData.append(sectionModel)
            self.listData?.value = listData
        }
    }
    
    func handleInputString(string: String) -> String? {
        var result = string
        var count = 0
        var indexPlus = 0
        if string.count > 5 {
            for (index, char) in string.enumerated() {
                count = count + 1
                if count == 5 && index != result.count - indexPlus - 1 {
                    if char == Character(" ") {
                        result.insert("\n", at: String.Index.init(encodedOffset: index + 1 + indexPlus))
                        indexPlus = indexPlus + 1
                        count = 0
                    } else {
                        return nil
                    }
                    
                }
            }
            
            var array = result.split(separator: Character.init("\n"))
            var tempArray: [String] = []
            for (index, _) in array.enumerated() {
                let text = "\(index+1)/\(array.count) \(array[index])"
                tempArray.append(text)

            }
            result = tempArray.joined(separator: "\n")
        }
        return result
    }
}
