//
//  FileManagerBootcamp.swift
//  IntermediateBootcamp
//
//  Created by Jaxson Nelson on 3/2/22.
//

import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    func saveImage(image: UIImage, name: String) {
        guard
            let data = image.pngData(),
            let path = getPathForImage(name: name) else {
                print("Error getting data.")
                return
            }

        
        do {
             try data.write(to: path)
            print("Success Saving")
        } catch let error {
            print("Error saving \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        
        guard let path = getPathForImage(name: name)?.path,
              FileManager.default.fileExists(atPath: path) else {
                  print("Error getting path")
                  return nil
              }
        return UIImage(contentsOfFile: path)
    }
    
    func getPathForImage(name: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(name).png") else {
            print("Error getting path")
            return nil
        }
        return path
    }
}

class FileManagerViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let imageName: String = "justthedude"
    let manager = LocalFileManager.instance
    
    init() {
        getImageFromAssestsFolder()
    }
    func getImageFromAssestsFolder() {
        image = UIImage(named: imageName)
    }
    
    func saveImage() {
        guard let image = image else { return }
        manager.saveImage(image: image, name: imageName)
    }
    
}

struct FileManagerBootcamp: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                    .cornerRadius(10)
                }
                
                Button(action: {
                    vm.saveImage()
                }, label: {
                    Text("Save to Fm")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .padding(.horizontal)
                        .background(Color.blue)
                        .cornerRadius(10)
                })

                
                Spacer()
            }
            .navigationTitle("File Manager")
        }
    }
}

struct FileManagerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootcamp()
    }
}
