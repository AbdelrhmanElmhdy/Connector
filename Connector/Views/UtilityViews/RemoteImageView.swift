//
//  RemoteImageView.swift
//  Connector
//
//  Created by Abdelrhman Elmahdy on 14/07/2022.
//

import UIKit
import ShimmerSwift

let imageCache = NSCache<AnyObject, AnyObject>()

class RemoteImageView: UIImageView {
	
	let shimmeringView: ShimmeringView = {
		let view = ShimmeringView()
		view.layer.cornerRadius = 8
		view.shimmerSpeed = 0.1
		view.shimmerPauseDuration = 0.8
		view.isShimmering = true
		let contentView = UIView()
		contentView.backgroundColor = .lowContrastGray
		view.contentView = contentView
		
		return view
	}()
	
	var source: URL? {
		didSet {
			if let source = source {
				shimmeringView.isShimmering = true
				shimmeringView.isHidden = false
				setImage(from: source)
			} else {
				backgroundColor = .systemGray5
				image = UIImage.profilePicturePlaceHolder
			}
		}
	}
	
	let isRound: Bool
	
	override var bounds: CGRect {
		didSet {
			guard isRound else { return }
			layer.cornerRadius = bounds.height / 2
			clipsToBounds = true
		}
	}
	
	override var image: UIImage? {
		didSet {
			if image != nil {
				shimmeringView.isShimmering = false
				shimmeringView.isHidden = true
			}
		}
	}
	
	init(source: URL? = nil, isRound: Bool = false, frame: CGRect = .zero) {
		self.source = source
		self.isRound = isRound
		super.init(frame: frame)
		
		addSubview(shimmeringView)
		shimmeringView.fillSuperView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setImage(from source: URL) {
		
		if let imageFromCache = imageCache.object(forKey: source.absoluteURL as AnyObject) as? UIImage {
			self.image = imageFromCache
			return
		}
		
		let task = URLSession.shared.dataTask(with: source) { data, response, error in
			guard let data = data, error == nil else { return }
			
			DispatchQueue.main.async() {
				if let image = UIImage(data: data) {
					imageCache.setObject(image, forKey: source.absoluteURL as AnyObject)
					self.image = image
				}
			}
		}
		
		task.resume()
	}
	
}

