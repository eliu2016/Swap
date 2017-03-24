//
//  SetNameViewController.swift
//  Swap
//
//  Created by Dr. Stephen, Ph.D on 12/8/16.
//
//

import UIKit

/// Default Profile Picture Image URL String
let defaultImage: String = "http://bsccongress.com/im4/teamstijl-person-icon-blue-clip-art.png"

class SetNameViewController: UIViewController {

    
    @IBOutlet var firstnameField: UITextField!
    @IBOutlet var lastnameField: UITextField!
   

  //  let swapCodeImage = "https://dashboard.unitag.io/qreator/generate?setting=%7B%22LAYOUT%22%3A%7B%22COLORBG%22%3A%22ffffff%22%2C%22COLOR1%22%3A%221fbcd3%22%7D%2C%22EYES%22%3A%7B%22EYE_TYPE%22%3A%22Grid%22%7D%2C%22BODY_TYPE%22%3A5%2C%22E%22%3A%22H%22%2C%22LOGO%22%3A%7B%22L_NAME%22%3A%22https%3A%2F%2Fstatic-unitag.com%2Ffile%2Ffreeqr%2Fcfc031a5ddb114b66233e4e1762b93cb.png%22%2C%22EXCAVATE%22%3Atrue%2C%22L_X_Norm%22%3A0.4%2C%22L_Y_Norm%22%3A0.396%2C%22L_WIDTH%22%3A0.2%2C%22L_LENGTH%22%3A0.208%7D%7D&data=%7B%22TYPE%22%3A%22text%22%2C%22DATA%22%3A%7B%22TEXT%22%3A%22http://swapapp.co/\(getUsernameOfSignedInUser())%22%2C%22URL%22%3A%22%22%7D%7D"
    
    
    
    
    @IBAction func continueToSetProfileInfo(_ sender: UIButton) {
        
        // Sets the Swap User's initial data in the database 
        // By default, the user is NOT searchable 
       
        
        if (firstnameField.text != "" && lastnameField.text != ""){
            
            
            
            saveFirstname(name: firstnameField.text!.capitalized)
            saveLastname(name: lastnameField.text!.capitalized)
            
            self.performSegue(withIdentifier: "toBirthdayController", sender: nil)
            
            print("the saved firstname is \(getSavedFirstname()) ")
        }
        else{
          
            UIAlertView(title: "Error",
                       message: "First Name And Last Name Are Required",
                       delegate: nil,
                       cancelButtonTitle: "Ok").show()
        }
    
    }
    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Autofills the fields based on if the information is in the user's addressbook already
        
        firstnameField.text = getSavedFirstname() ?? ""
        lastnameField.text = getSavedLastname() ?? ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        saveViewController(viewController: self)
        
        firstnameField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        firstnameField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
