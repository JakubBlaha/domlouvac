import Foundation
import PhotosUI
import SwiftUI

class ImagePickerCoordinator: NSObject, PHPickerViewControllerDelegate {
    var parent: ImagePicker

    init(parent: ImagePicker) {
        self.parent = parent
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let provider = results.first?.itemProvider else { return }

        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    if let uiImage = image as? UIImage {
                        self.parent.selectedImage = uiImage
                        if let imageData = uiImage.pngData() {
                            self.parent.base64EncodedImage = imageData.base64EncodedString()
                        }
                    }
                }
            }
        }
    }
}
