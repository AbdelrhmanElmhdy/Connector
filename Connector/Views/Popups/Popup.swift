import UIKit

class Popup: UIView {
	
	// MARK: Properties
	
	lazy var blurOverlay: UIVisualEffectView = {
		let blurEffect = UIBlurEffect(style: blurEffectStyle)
		
		let visualEffectView = UIVisualEffectView(effect: blurEffect)
		visualEffectView.translatesAutoresizingMaskIntoConstraints = false
		
		return visualEffectView
	}()
	
	lazy var dismissButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		
		button.setImage(.cancel, for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(handleOverlayAndDismissButtonTab), for: .touchUpInside)
		button.imageView?.contentMode = .scaleAspectFit
		
		return button
	}()
	
	lazy var contentView: UIView = {
		let view = UIView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		
		view.backgroundColor = .secondarySystemGroupedBackground
		view.layer.cornerRadius = 18
		view.alpha = 0
		view.scale(to: contentViewInitialScale)
		
		return view
	}()
	
	lazy var overlayTapGestureRecognizer: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleOverlayAndDismissButtonTab))
	
	var blurEffectStyle: UIBlurEffect.Style {
		return traitCollection.userInterfaceStyle == .dark ? .light : .dark
	}
	
	let contentViewInitialScale: CGFloat = 1.2
	var popupDismissalHandler: (() -> Void)?
	
	var hideOnOverlayTap: Bool = true {
		didSet {
			overlayTapGestureRecognizer.isEnabled = hideOnOverlayTap
		}
	}
	
	init() {
		super.init(frame: .zero)
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: views setups
	
	func setupSubViews() {
		addSubview(blurOverlay)
		blurOverlay.fillSuperView()
		
		setupDismissButton()
		addSubview(contentView)
		setupContentView()
	}
	
	func setupDismissButton() {
		addSubview(dismissButton)
		
		NSLayoutConstraint.activate([
			dismissButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
			dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
			dismissButton.heightAnchor.constraint(equalToConstant: 18),
			dismissButton.widthAnchor.constraint(equalToConstant: 18),
		])
	}
	
	func setupContentView() {
		NSLayoutConstraint.activate([
			contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
			contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
			contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: 0.2),
			contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.78),
		])
	}
	
	@objc func handleOverlayAndDismissButtonTab() {
		dismiss(animated: true)
	}
	
	// MARK: Tools
	
	func present(animated: Bool) {
		guard let window = UIApplication.shared.keyWindow else { return }
		window.addSubview(self)
		
		prepareForPresentation()
		
		let animationDuration: TimeInterval = animated ? 0.2 : 0
		animateContentViewIn(withDuration: animationDuration)
	}
	
	func dismiss(animated: Bool) {
		guard superview != nil else { return }
		
		func animationCompletionHandler(completed: Bool) {
			self.removeFromSuperview()
			self.popupDismissalHandler?()
		}
		
		if animated {
			animateContentViewOut(completionHandler: animationCompletionHandler)
		} else {
			animationCompletionHandler(completed: true)
		}
	}
	
	func prepareForPresentation() {
		if !(blurOverlay.gestureRecognizers?.contains(overlayTapGestureRecognizer) ?? false) {
			blurOverlay.addGestureRecognizer(overlayTapGestureRecognizer)
		}
		
		contentView.scale(to: contentViewInitialScale)
		blurOverlay.alpha = 1
		dismissButton.alpha = 1
		
		fillSuperView()
	}
	
	func animateContentViewIn(withDuration animationDuration: TimeInterval) {
		UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
			self.contentView.alpha = 1
			self.contentView.scale(to: 1)
		}
	}
	
	func animateContentViewOut(completionHandler: @escaping (Bool) -> Void) {
		UIView.animate(
			withDuration: 0.1,
			delay: 0,
			options: .curveEaseIn,
			animations: {
				self.contentView.alpha = 0
				self.contentView.scale(to: self.contentViewInitialScale)
				self.blurOverlay.alpha = 0
				self.dismissButton.alpha = 0
			},
			completion: completionHandler
		)
	}
	
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		blurOverlay.effect = UIBlurEffect(style: blurEffectStyle)
	}
}
