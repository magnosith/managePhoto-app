//
//  ViewController.swift
//  managePhoto-app
//
//  Created by Student on 22/06/23.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
        guard let image = imageView.image else {return}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present (activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com"){
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController (title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
       
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            action in
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            print("User selected Camera action")
        })
            alertController.addAction(cameraAction)
        }
       
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
        let photoLibraryAction = UIAlertAction(title: "Choose from Library Photo", style: .default, handler: {
            action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            print("User selected Photo Library action")
        })
            alertController.addAction(photoLibraryAction)
        }
       
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail Here")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["magnosith@icloud.com"])
        mailComposer.setSubject("Take my picture!")
        mailComposer.setMessageBody("Hello there! Look my picture, that i taked yesterday", isHTML: false)
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9){
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        present(mailComposer, animated: true, completion: nil)
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
            dismiss(animated: true, completion: nil)
        }
    }
    
}

