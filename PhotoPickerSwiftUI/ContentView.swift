//
//  ContentView.swift
//  PhotoPickerSwiftUI
//
//  Created by Dilara Akdeniz on 26.07.2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State var selectedItem : [PhotosPickerItem] = [] //Birden fazla fotoğraf seçilmesini istersek dizi yapmak mantıklı olur. Ama biz 1 tane seçtireceğiz
    @State var data : Data?
    
    var body: some View {
        VStack {
            //Aşağıda dataya çevrmiştik, onu gösteriyoruz.
            if let data = data {
                if let selectedImage = UIImage(data: data) {
                    Spacer()
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 300, height: 250, alignment: .center)
                }
            }
            Spacer()
            //selection -> seçildikten sonra hangi değişkene atansın, maxSelectionCount -> kullanıcı en fazla kaç tane fotoğraf seçebilsin, matching -> kullanıcı ne seçsin(görsel, video...)
            PhotosPicker(selection: $selectedItem,maxSelectionCount: 1, matching: .images) {
                Text("Select Image")
                //Fotoğraf seçildikten sonra ne olacak.
            }.onChange(of: selectedItem) { newValue in
                guard let item = selectedItem.first else {
                    return
                }
                //PhotosPicker data olmalı. O yüzden alınan fotoğraf dataya çevrilir ve bu daha üzerinden işlem yapılır.
                item.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            self.data = data
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
