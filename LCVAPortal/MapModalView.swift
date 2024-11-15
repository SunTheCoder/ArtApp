import SwiftUI
import MapKit

struct MapModalView: View {
    let artPiece: ArtPiece
    @State private var shouldReloadMap = false

    var body: some View {
        VStack {
            Text(artPiece.description)
                .font(.system(size: 14))

                .padding()
            
            if shouldReloadMap {
                MapViewRepresentable(artPiece: artPiece)
                    .frame(width: 250, height: 250)
                    .ignoresSafeArea(edges: .all)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .shadow(radius: 3)
            }

            Divider()
            
            Text("Share your thoughts with your peers:")
                .font(.system(size: 12))
                .padding(2)
            
            // ChatView added here
            ChatView(artPieceID: artPiece.id)
                .frame(maxHeight: 380)
                .padding(.horizontal)

        }
        .navigationTitle(artPiece.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                shouldReloadMap = true
            }
        }
    }
}
