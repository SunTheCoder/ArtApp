//
//  ExhibitionDetailModalView.swift
//  LCVAPortal
//
//  Created by Sun English on 11/15/24.
//

import SwiftUI
import MapKit


struct ExhibitionDetailModalView: View {
    let exhibition: Exhibition
   
    @Binding var isPresented: Bool // Binding to control modal visibility
    
    var body: some View {
        NavigationView {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Display exhibition image
                    AsyncImage(url: URL(string: exhibition.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .accessibilityLabel(Text("Image of \(exhibition.title)"))
                    } placeholder: {
                        ProgressView()
                            .accessibilityHidden(true) // Hide loading indicator from VoiceOver
                    }
                    .frame(maxHeight: 300)
                    
                    // Display title
                    Text(exhibition.title)
                        .font(.largeTitle)
                        .bold()
                        .padding(.vertical)
                        .accessibilityAddTraits(.isHeader)
                        .multilineTextAlignment(.center)
                    
                    // Reception, Closing, Description, and Links
                    Text("Reception:\n\(exhibition.reception)")
                        .font(.body)
                        .padding(.vertical)
                        .accessibilityLabel(Text("Reception: \(exhibition.reception)"))
                    
                    Text("Closing:\n\(exhibition.closing)")
                        .font(.body)
                        .padding(.vertical)
                        .accessibilityLabel(Text("Closing: \(exhibition.closing)"))
                    
                    Link("Survey Link", destination: URL(string: exhibition.surveyUrl)!)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .accessibilityLabel("Open Survey Link")
                    
                    Text(exhibition.description)
                        .font(.body)
                        .padding(.vertical)
                        .accessibilityLabel(Text("Description: \(exhibition.description)"))
                    
                    // Extra Content Section
                    Text("Extra Content:")
                        .font(.headline)
                        .padding(.top)
                    
                    if let extraLink = exhibition.extraLink, !extraLink.isEmpty, let url = URL(string: extraLink) {
                        Link(extraLink, destination: url)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .underline()
                            .accessibilityLabel(Text("Visit \(extraLink)"))
                    } else {
                        Text("No additional link available")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .onAppear {
                                    print("Exhibition Details: \(exhibition)")
                                }
            }
            .navigationTitle("Exhibition Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                                print("Exhibition Details: \(exhibition)")
                            }
        }
    }
}
