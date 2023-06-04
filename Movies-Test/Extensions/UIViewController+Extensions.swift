//
//  UIViewController+Extensions.swift
//  Movies-Test
//
//  Created by Amr Fawaz on 02/06/2023.
//

import UIKit
import MBProgressHUD
import SwiftMessages

extension UIViewController {

    func showMessage(message: String, messageType: Theme){
        switch messageType{
        case .error:
            displayErrorMessage(message: message)
        case .success:
            displaySuccessMessage(message: message)
        case .info:
            displayInfoMessage(message: message)
        case .warning:
            break
        }
    }
    private func displayErrorMessage(message: String){
        let error = MessageView.viewFromNib(layout: .cardView)
        error.bodyLabel?.font = UIFont.systemFont(ofSize: 15)
        error.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        error.bodyLabel?.textAlignment = .right
        error.titleLabel?.textAlignment = .right
        error.configureTheme(.error)
        error.configureDropShadow()
        error.button?.isHidden = true
        error.configureContent(title: "خطأ", body: message)
        var errorConfig = SwiftMessages.defaultConfig
        errorConfig.presentationStyle = .top
        errorConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: errorConfig, view: error)
    }
    private func displaySuccessMessage(message: String){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.bodyLabel?.font = UIFont.systemFont(ofSize: 15)
        success.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        success.bodyLabel?.textAlignment = .right
        success.titleLabel?.textAlignment = .right
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "نجح", body: message)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    private func displayInfoMessage(message: String){
        let info = MessageView.viewFromNib(layout: .cardView)
        info.bodyLabel?.font = UIFont.systemFont(ofSize: 15)
        info.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        info.bodyLabel?.textAlignment = .right
        info.titleLabel?.textAlignment = .right
        info.configureTheme(.info)
//        info.backgroundColor = UIColor.GRADIENT_DARK_BLUE
        let iconImage = IconStyle.default.image(theme: .info)
        info.configureTheme(backgroundColor: .blue, foregroundColor: .white, iconImage: iconImage)
        info.configureDropShadow()
        info.configureContent(title: "تنبيه",body: message)
        info.button?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: infoConfig, view: info)
    }
}

fileprivate let unknownErrorMessage = NSLocalizedString("An unknown error has occurred", comment: "A message showing that an error has occurred, but the specific error causing it is unknown.")

extension UIViewController {
    
    /// Show an alert on the view controller.
    func showAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = [.ok], completion: (() -> Void)? = nil) {
        
        guard Thread.isMainThread else {
            DispatchQueue.main.async {
                self.showAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, completion: completion)
            }
            return
        }
        let alert = UIAlertController.createAlert(title: title, message: message, preferredStyle: preferredStyle, actions: actions, completion: completion)
        
        present(alert, animated: true, completion: completion)
    }
    
    /// Show an alert on the view controller.
    func showAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, action: UIAlertAction, completion: (() -> Void)? = nil) {
        showAlert(title: title, message: message, preferredStyle: preferredStyle, actions: [action], completion: completion)
    }
    
    /// Show an alert on the view controller for the specified error.
    func showErrorAlert(title: String? = nil, error: Error?, unknownMessage: String = unknownErrorMessage, actions: [UIAlertAction] = [.ok], completion: (() -> Void)? = nil) {
        showAlert(title: title, message: error?.localizedDescription ?? unknownMessage, actions: actions, completion: completion)
    }
    
    /// Show an alert on the view controller for the specified error.
    func showErrorAlert(title: String? = nil, error: Error?, unknownMessage: String = unknownErrorMessage, action: UIAlertAction, completion: (() -> Void)? = nil) {
        showErrorAlert(title: title, error: error, actions: [action], completion: completion)
    }
    
}

extension UIAlertController {
    
    static func createAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = [.ok], completion: (() -> Void)? = nil) -> UIAlertController {
        let alert = self.init(title: title, message: message, preferredStyle: preferredStyle)
        let titleAtt = attributedText(string: title ?? "", font: UIFont.boldSystemFont(ofSize: 15).fontName)
        let messageAtt = attributedText(string: message ?? "", font: UIFont.systemFont(ofSize: 13).fontName)
        
        alert.setValue(titleAtt, forKey: "attributedTitle")
        alert.setValue(messageAtt, forKey: "attributedMessage")
        
        actions.forEach({ alert.addAction($0) })
        return alert
    }
    
}

// Extend UIAlertAction to have quick and Swift-like initializers
extension UIAlertAction {
    
    static func cancel(_ title: String = NSLocalizedString("Cancel", comment: ""), handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel, handler: handler)
    }
    
    static func ok(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return self.cancel(NSLocalizedString("موافق", comment: ""), handler: handler)
    }
    
    static func dismiss(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return self.cancel(NSLocalizedString("Dismiss", comment: ""), handler: handler)
    }
    
    static func normal(_ title: String = "ليس الأن", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default, handler: handler)
    }
    
    static func destructive(_ title: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: handler)
    }
    
    static func delete(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: handler)
    }
    
    // Allow being accessed as properties:
    
    static var cancel: UIAlertAction {
        return .cancel()
    }
    
    static var ok: UIAlertAction {
        return .ok()
    }
    
    static var dismiss: UIAlertAction {
        return .dismiss()
    }
    
    static var delete: UIAlertAction {
        return .delete()
    }
    
}

func attributedText(string: String, font: String = UIFont.systemFont(ofSize: 14).fontName, size: CGFloat = 14, color: UIColor = .gray)-> NSMutableAttributedString {
    let font = UIFont(name: font, size: size)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font ?? UIFont.systemFont(ofSize: 15),
        .foregroundColor: color
    ]
    return NSMutableAttributedString(string: string, attributes: attributes)
}
