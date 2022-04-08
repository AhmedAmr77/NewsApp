//
//  PickerTextField.swift
//  NewsApp
//
//  Created by Ahmed Sharf on 4/8/22.
//

import UIKit

class PickerTextField: UITextField {
    
    private var picker: UIPickerView! = UIPickerView()
    private var selectedIndex = 0
    
    var dataList = [String]()
    var didSelect: ((Int)->())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        delegate = self
        inputView = picker
        
        picker.delegate = self
        picker.dataSource = self
        
        createDownArrow()
        setToolBar()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        .null
    }
    
    override func resignFirstResponder() -> Bool {
        didSelect?(selectedIndex)
        return super.resignFirstResponder()
    }
    
    private func createDownArrow() {
        let image = #imageLiteral(resourceName: "drop-down-arrow")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: frame.maxX - 26, y: frame.midY, width: 10, height: 10)
        addSubview(imageView)
    }
    
    private func setToolBar() {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 35.0))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([flexibleSpace, done], animated: false)
        inputAccessoryView = toolBar
    }
    @objc private func donePressed() {
        let _ = resignFirstResponder()
    }
    
    private func selectFisrtItem() {
        pickerView(picker, didSelectRow: 0, inComponent: 0)
    }
}

extension PickerTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectFisrtItem()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
}

extension PickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard !dataList.isEmpty else { return }
        text = dataList[row]
        selectedIndex = row
    }
}
