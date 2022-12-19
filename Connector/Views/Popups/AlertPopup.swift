import UIKit

class AlertPopup: Popup {
    
    let imageView: UIImageView = {
        var imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = .highContrastText
        
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        
        return label
    }()
	
	var actionsRow: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.alignment = .center
		stackView.distribution = .fillEqually
		
		return stackView
	}()
	
	var actions: [AlertPopupAction] = [] {
		didSet {
			actionsRow.removeAllArrangedSubviews()
			
            if actions.count == 1 {
                actionsRow.addSeparatorView(withColor: .separator, andWidth: 0.5)
            }
            
			guard !actions.isEmpty else {
				actionsRowHeightConstraint.constant = 0
				return
			}
			
			for (index, action) in actions.enumerated() {
				action.isLastAction = index == actions.count - 1
				actionsRow.addArrangedSubview(action)
			}
			
			actionsRowHeightConstraint.constant = 40
		}
	}
	
	var actionsRowHeightConstraint: NSLayoutConstraint!
	var titleLabelTopAnchorConstraint: NSLayoutConstraint?
    
    override func setupSubViews() {
		super.setupSubViews()
        setupImageView()
        setupTitleLabel()
        setupMessageLabel()
		setupActionsRow()
    }
	
    func setupImageView() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.35),
        ])
    }
    
    func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        		
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    func setupMessageLabel() {
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
	
	func setupActionsRow() {
		contentView.addSubview(actionsRow)
		
		actionsRowHeightConstraint = actionsRow.heightAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			actionsRow.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 18),
			actionsRow.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			actionsRow.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
			actionsRow.widthAnchor.constraint(equalTo: contentView.widthAnchor),
			actionsRowHeightConstraint,
		])
	}
    
	func present(withImage image: UIImage? = nil, title: String, message: String?, actions: [AlertPopupAction] = []) {
        imageView.image = image
        titleLabel.text = title
        messageLabel.text = message
		self.actions = actions
		
        present(animated: true)
        
		adjustTitleLabelTopAnchorConstraint(image)
    }
    
    func presentAsError(withMessage message: String, advice: String? = nil, actions: [AlertPopupAction]? = nil) {
        let dismissAction = AlertPopupAction(title: "Ok".localized, style: .normal) { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let image = UIImage(named: "errorImage")
        let actions = actions ?? [dismissAction]
        
        if let advice = advice, !advice.isEmpty {
            present(withImage: image, title: message, message: advice, actions: actions)
            return
        }
        
        let title = "Error".localized
        present(withImage: image, title: title, message: message, actions: actions)
    }
    
    func presentAsInternetConnectionError() {
        presentAsError(withMessage: "No Internet Connection".localized)
    }
	
    /// When asking the user if they're sure they want to proceed in something
    func presentAsConfirmationAlert(title: String, message: String, confirmationButtonTitle: String, confirmationButtonStyle: AlertPopupAction.Style, confirmationHandler: @escaping () -> Void) {
		let cancelAction = AlertPopupAction(title: "Cancel".localized, style: .normal) {[weak self] in
			self?.dismiss(animated: true)
		}
		
		let confirmAction = AlertPopupAction(title: confirmationButtonTitle, style: confirmationButtonStyle, handler: confirmationHandler)
		
		present(title: title, message: message, actions: [cancelAction, confirmAction])
	}
	
	func adjustTitleLabelTopAnchorConstraint(_ image: UIImage?) {
		titleLabelTopAnchorConstraint?.isActive = false
		
		titleLabelTopAnchorConstraint = image != nil
			? titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16)
			: titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
		
		titleLabelTopAnchorConstraint?.isActive = true
	}
    
}
