//
//  MemeMeViewController.swift
//  MemeMe
//
//  Created by Abdalah on 4/1/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit

class MemeMeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var isUsingBottomDefaultText:Bool = true
    var isUsingTopDefaultText:Bool = true
    //let textFieldDelegate = TextFieldDelegate()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.isEnabled = false
        edittheText()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // when we dont have iphone and wwork in simlator to hidden botton camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.tabBarController?.tabBar.isHidden = true
         subscribeToKeyboardNotifications()
     
    
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
         shareButton.isEnabled = false
        self.tabBarController?.tabBar.isHidden = false
        configureBar(hidden: false)
    }
    func configureBar(hidden: Bool) {
        toolBar.isHidden = hidden
        navigationBar.isHidden = hidden
    }
    // mark : UIImagePickerController
    // to choose from lib
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imagePickerView.image = image
        picker.dismiss(animated: true, completion: nil)
         shareButton.isEnabled = true
        // to cancel when open album
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
        
    }
    //textfield
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == bottomTextField && isUsingBottomDefaultText {
            textField.text = ""
            isUsingBottomDefaultText = false
        }
        
        if textField == topTextField && isUsingTopDefaultText {
            textField.text = ""
            isUsingTopDefaultText = false
        }
    }
    func edittheText()
    {
        
        let memeTextAttributes:[NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.50,
        ]
        configureText(textField: topTextField, text: "TOP", defaultTextAttributes: memeTextAttributes)
        configureText(textField: bottomTextField, text: "BOTTOM", defaultTextAttributes: memeTextAttributes)
        
        
    }
    func configureText(textField: UITextField, text: String, defaultTextAttributes: [NSAttributedString.Key : Any]) {
        textField.defaultTextAttributes = defaultTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        textField.delegate =  self
        textField.textAlignment = .center
        textField.text = text
        textField.backgroundColor = .clear
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    //keyBoard
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
 
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name:UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
   
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
 
   
    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        configureBar(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        configureBar(hidden: false)
        
        return memedImage
    }
 
    func save() {
 
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    @IBAction func pickAnImage(_ sender: Any) {
        
        pickAnImage(sourceType : .photoLibrary)
    }
    
    
    @IBAction func camera(_ sender: Any) {
       
        pickAnImage(sourceType : .camera)
    }
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func cancelImage(_ sender: Any) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareButton.isEnabled = false
        if let _ = self.navigationController {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func Share(_ sender: Any) {

        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if !completed {
                print("cancelled")
                return
            }else{
                self.save()
                if let _ = self.navigationController {
                    self.navigationController!.popToRootViewController(animated: true)
    
                
                }

            }

        }
    
    }
}



