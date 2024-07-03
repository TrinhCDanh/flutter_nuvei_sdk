//
//  FLNativeView.swift
//  flutter_nuvei_sdk
//
//  Created by Trinh Danh on 21/3/24.
//

import Flutter
import UIKit
import NuveiSimplyConnectSDK

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var methodChannel: FlutterMethodChannel
    private let cardDataCallback: CardDataCallback?

    init(
        messenger: FlutterBinaryMessenger,
        methodChannel: FlutterMethodChannel,
        cardDataCallback: CardDataCallback?
    ) {
        self.messenger = messenger
        self.methodChannel = methodChannel
        self.cardDataCallback = cardDataCallback
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        guard let argsDict = args as? [String: Any],
                      let containerWidth = argsDict["containerWidth"] as? CGFloat else {
            return UIView() as! FlutterPlatformView
        }
        
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            methodChannel: methodChannel,
            cardDataCallback: cardDataCallback,
            containerWidth: containerWidth
        )
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView
    private var containerWidth: CGFloat
    private var methodChannel: FlutterMethodChannel
    private let cardDataCallback: CardDataCallback?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        methodChannel: FlutterMethodChannel,
        cardDataCallback: CardDataCallback?,
        containerWidth: CGFloat?
    ) {
        _view = UIView()
        self.methodChannel = methodChannel
        self.cardDataCallback = cardDataCallback
        self.containerWidth = containerWidth ?? 400
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        do {
            let creditCardField = try NuveiFields.createCreditCardField()
            var allTextFields = [UITextField]()
            var allLabels = [UILabel]()
            
            creditCardField.onInputUpdated = { hasFocus in
                print(hasFocus)
                self.methodChannel.invokeMethod("onInputUpdated", arguments: String(hasFocus))                
            }
            creditCardField.onInputValidated = { errors in
                let numberErrorTextView = allLabels[3].text
                let cardHolderNameErrorTextView = allLabels[1].text
                let expiryDateErrorTextView = allLabels[5].text
                let cvvErrorTextView = allLabels[7].text
                
                let hasError = ((numberErrorTextView?.isEmpty) != nil) || ((cardHolderNameErrorTextView?.isEmpty) != nil) || ((expiryDateErrorTextView?.isEmpty) != nil) || ((cvvErrorTextView?.isEmpty) != nil)
                self.methodChannel.invokeMethod("onInputValidated", arguments: String(hasError))
            }
            _view.addSubview(creditCardField)
            
            // Set width for field
//            _view.subviews[0].width(self.containerWidth)
             
            // Find UITextField (input) and UILabel (error message)
            let (textFields, labels) = _view.findTextFieldsAndLabels()
            allTextFields = textFields
            allLabels = labels
            
            let cardNumber: UITextField = allTextFields[1]
            let cardHolderName: UITextField = allTextFields[0]
            let expiryDate: UITextField = allTextFields[2]
            let cvv: UITextField = allTextFields[3]            
            self.cardDataCallback!(creditCardField, cardNumber, cardHolderName, expiryDate, cvv)
        } catch {
            print("Error info: \(error)")
        }
    }
}

extension UIView {
    func findTextFieldsAndLabels() -> (textFields: [UITextField], labels: [UILabel]) {
        var textFields = [UITextField]()
        var labels = [UILabel]()
        for subview in subviews {
            if let textField = subview as? UITextField {
                textFields.append(textField)
            } else if let label = subview as? UILabel {
                labels.append(label)
            } else {
                let (subviewTextFields, subviewLabels) = subview.findTextFieldsAndLabels()
                textFields += subviewTextFields
                labels += subviewLabels
            }
        }
        return (textFields, labels)
    }
}

extension UIView {
    func findTextFields() -> [UITextField] {
        var textFields = [UITextField]()
        for subview in subviews {
            if let textField = subview as? UITextField {
                textFields.append(textField)
            } else {
                textFields += subview.findTextFields()
            }
        }
        return textFields
    }
    
    func findLabels() -> [UILabel] {
        var textFields = [UILabel]()
        for subview in subviews {
            if let textField = subview as? UILabel {
                textFields.append(textField)
            } else {
                textFields += subview.findLabels()
            }
        }
        return textFields
    }
}
