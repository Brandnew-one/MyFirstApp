//
//  Document+Extension.swift
//  FoodStory
//
//  Created by 신상원 on 2021/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //1. 이미지 저장할 경로 설정 : Document 폴더
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        //Desktop/~~/~~/folder/222.png
        let imageURL = filePath.appendingPathComponent(imageName)
        
        //3. 이미지 압축(optional) image.pngData()
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인 (만약 최종 경로에 동일한 파일이 있는 경우)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            }
            catch {
                print("이미지 삭제하지 못했습니다.")
            }
        }
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        }
        catch {
            print("이미지 저장 실패")
        }
    }
    
    
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {

        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        let imageURL = filePath.appendingPathComponent(imageName)
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    func deleteImageFromDocumentDirectory(imageName: String) {
        //1. 이미지 저장할 경로 설정 : Document 폴더
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filePath = documentDirectory.appendingPathComponent("Image")
        if !FileManager.default.fileExists(atPath: filePath.path) {
            do {
                try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        //2. 이미지 파일 이름 & 최종 경로 설정
        //Desktop/~~/~~/folder/222.png
        let imageURL = filePath.appendingPathComponent(imageName)
        
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
        //4-1. 이미지 경로 여부 확인 (만약 최종 경로에 동일한 파일이 있는 경우)
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2. 기존 경로에 있는 이미지 삭제
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            }
            catch {
                print("이미지 삭제하지 못했습니다.")
            }
        }
    }
}
