//
//  PickerTextField.swift
//  Hi-Touch
//
//  Created by 吉野史也 on 2019/02/16.
//  Copyright © 2019年 yoshinofumiya. All rights reserved.
//

import UIKit

class PickerTextField: UITextField, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    var dataList = [String]()

    /*-----------------------------------------------------------------------------------------*/
    //MARK: setup PickerView function
    
    func setup(list: [String]) {
        self.dataList = list
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        
        let toolbar = UIToolbar()
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        toolbar.setItems([cancelItem, doneItem], animated: true)

        self.inputView = picker
        self.inputAccessoryView = toolbar
    }
    
    /*-----------------------------------------------------------------------------------------*/
    //MARK: - UIPickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = dataList[row]
    }

    
    /*-----------------------------------------------------------------------------------------*/
    //MARK: PickerView Toolbar and ButtonItem function
    
    @objc func cancel() {
        self.text = ""
        self.endEditing(true)
    }

    @objc func done() {
        self.endEditing(true)
    }
}
