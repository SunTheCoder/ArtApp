//
//  ArtistDetailModalView.swift
//  LCVAPortal
//
//  Created by Sun English on 11/15/24.
//

import SwiftUI
import AVKit

struct ArtistDetailModalView: View {
    let artist: Artist
    @Binding var isPresented: Bool // Binding to control modal visibility
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Text(artist.name)
                        .font(.title)
                        .bold()
                        .padding(.top)
                    
                    Text(artist.bio)
                        .font(.body)
                        .padding(.bottom)
                    
                    Text("Artwork")
                        .font(.headline)
                    
                    ForEach(artist.videos.prefix(3), id: \.self) { video in
                        VideoPlayerView(videoName: video)
                            .frame(width: 300, height: 250)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.vertical, 10)
                    }
                    
                    ForEach(artist.imageUrls, id: \.self) { imageUrl in
                        Image(imageUrl)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)  // Set the size as desired
                            .clipShape(RoundedRectangle(cornerRadius: 10))  // Optional: Rounded corners
                            .padding(.vertical, 10)  // Vertical padding to center the images in the ScrollView
                    }
                }
                .padding()
            }
            .navigationTitle("Local Artist Spotlight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}
