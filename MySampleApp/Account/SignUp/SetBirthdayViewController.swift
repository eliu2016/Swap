//
//  setBirthdayViewController.swift
//  Swap
//
//  Created by David Slakter on 12/17/16.
//
//  Description: Contains a date picker and a UITextfield to allow the user to set their birthday and then
//  saves this information.
//


import Foundation


class SetBirthdayViewController: UIViewController {
    
    @IBOutlet var dateField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var continueButton: UIButton!
    
    
    override func viewDidLoad() {
        
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
    
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateField.text = dateFormatter.string(from: sender.date)
        
    }
    @IBAction func didPressContinue(_ sender: Any) {
  
        
        /*show loading overlay
        let loadingOverlay = ShowLoadingOverlay()
        let blackOverlay = loadingOverlay.showBlackOverlay()
        let loadingSymbol = loadingOverlay.showLoadingSymbol(view: self.view)
        
        view.addSubview(blackOverlay)
        view.addSubview(loadingSymbol)
        datePicker.isEnabled = false
        continueButton.isEnabled = false*/
        
        
        if dateField.text == ""{
            
            UIAlertView(title: "Error",
                        message: "Enter Your Birthday",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
            
        }
        else{
            UserDefaults.standard.set(datePicker.date.timeIntervalSince1970 as Double, forKey: "birthday")
            
            self.performSegue(withIdentifier: "toEmailController", sender: nil)
        }

        
    }


    @IBAction func didTapBack(_ sender: Any) {
    
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        saveViewController(viewController: self)
    }
}
