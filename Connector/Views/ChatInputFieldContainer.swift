//
//  InputFieldContainer.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 11/07/2022.
//

import UIKit

class ChatInputFieldContainer: UIView {

    static let minHeight: CGFloat = 40
    static let maxHeight: CGFloat = 200
    
    let sendBtn: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(systemName: "arrow.up")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .accent
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let inputField: EditableTextView = {
        let textView = EditableTextView(frame: .zero)
        
        let textViewFontSize: CGFloat = 14
        textView.font = .systemFont(ofSize: 14)
        textView.placeholder = "Message".localized
        textView.isScrollEnabled = false
        
        let textViewHeight = textViewFontSize
        let verticalPadding = ChatInputFieldContainer.minHeight - textViewHeight
        
        textView.textContainerInset =  UIEdgeInsets(top: verticalPadding / 2, left: 0, bottom: verticalPadding / 2, right: 0)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override var bounds: CGRect {
        didSet {
            if bounds.height >= ChatInputFieldContainer.maxHeight {
                inputField.isScrollEnabled = true
            } else {
                inputField.isScrollEnabled = false
                inputField.sizeToFit()
            }
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        setupSendBtn()
        setupInputView()
    }
    
    func setupSendBtn() {
        addSubview(sendBtn)
        
        
        let verticalPadding: CGFloat = 10
        let size: CGFloat = ChatInputFieldContainer.minHeight - verticalPadding
        
        NSLayoutConstraint.activate([
            sendBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(verticalPadding / 2) - 1),
            sendBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
            sendBtn.widthAnchor.constraint(equalToConstant: size),
            sendBtn.heightAnchor.constraint(equalToConstant: size),
        ])
        
        sendBtn.layer.cornerRadius = size / 2
    }
    
    func setupInputView() {
        addSubview(inputField)
        NSLayoutConstraint.activate([
            inputField.topAnchor.constraint(equalTo: self.topAnchor),
            inputField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            inputField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            inputField.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor, constant: -8),
        ])
    }
}
