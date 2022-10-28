//
//  UIImageView+.swift
//  NadoSunbae
//
//  Created by madilyn on 2022/08/06.
//

import UIKit

extension UIImageView {
    
    /// 컬러만 있는 Image를 ImageView에 넣어 주는 메서드
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    /// URL을 통해 이미지를 불러오는 메서드 + 캐싱
    func setImageUrl(_ imageURL: String) {
        let cacheKey = NSString(string: imageURL)
        
        /// 해당 Key에 캐시 이미지가 저장되어 있으면 이미지 사용
        if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            self.image = cachedImage
            return
        }
        
        if let requestURL = URL(string: imageURL) {
            let request = URLRequest(url: requestURL)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    
                    /// 다운받은 이미지를 캐시에 저장
                    ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                    
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
    }
}
