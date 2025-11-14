import SwiftUI
import PhotosUI

struct CreatePostScreen: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = CreatePostViewModel()
    @State private var selectedImages: [PhotosPickerItem] = []
    @State private var captionText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Media selection area
                if viewModel.selectedImages.isEmpty {
                    MediaSelectionView(selectedImages: $selectedImages)
                        .frame(maxHeight: 400)
                } else {
                    SelectedMediaView(
                        images: viewModel.selectedImages,
                        onRemove: viewModel.removeImage
                    )
                    .frame(maxHeight: 400)
                }

                Divider()

                // Caption and options
                CaptionSection(
                    caption: $captionText,
                    onTagPeople: { viewModel.tagPeople() },
                    onAddLocation: { viewModel.addLocation() }
                )

                Spacer()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        Task {
                            await viewModel.sharePost(caption: captionText)
                            dismiss()
                        }
                    }
                    .disabled(viewModel.selectedImages.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
        .onChange(of: selectedImages) { items in
            Task {
                await viewModel.loadImages(from: items)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct MediaSelectionView: View {
    @Binding var selectedImages: [PhotosPickerItem]
    let sampleImages = [
        "https://example.com/gallery1.jpg",
        "https://example.com/gallery2.jpg",
        "https://example.com/gallery3.jpg",
        "https://example.com/gallery4.jpg",
        "https://example.com/gallery5.jpg",
        "https://example.com/gallery6.jpg"
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Camera/Gallery options
            HStack(spacing: 16) {
                CameraButton()
                PhotosPickerButton(selectedImages: $selectedImages)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Sample gallery grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 3), spacing: 2) {
                ForEach(sampleImages.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: sampleImages[index])) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    .clipped()
                    .onTapGesture {
                        // Select sample image
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
}

struct CameraButton: View {
    @State private var showingImagePicker = false

    var body: some View {
        Button(action: {
            showingImagePicker = true
        }) {
            VStack(spacing: 8) {
                Image(systemName: "camera.fill")
                    .font(.title2)
                Text("Camera")
                    .font(.caption)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
        .sheet(isPresented: $showingImagePicker) {
            // Camera view would go here
            Text("Camera View")
        }
    }
}

struct PhotosPickerButton: View {
    @Binding var selectedImages: [PhotosPickerItem]

    var body: some View {
        PhotosPicker(
            selection: $selectedImages,
            maxSelectionCount: 10,
            matching: .images
        ) {
            VStack(spacing: 8) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.title2)
                Text("Gallery")
                    .font(.caption)
            }
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct SelectedMediaView: View {
    let images: [UIImage]
    let onRemove: (Int) -> Void
    @State private var currentIndex = 0

    var body: some View {
        VStack {
            // Main image display
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .tag(index)
                        .overlay(
                            Button(action: { onRemove(index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            .padding(12),
                            alignment: .topTrailing
                        )
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(maxHeight: 300)

            if images.count > 1 {
                // Thumbnail strip
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(images.indices, id: \.self) { index in
                            Image(uiImage: images[index])
                                .resizable()
                                .aspectRatio(1, contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(currentIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    withAnimation {
                                        currentIndex = index
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct CaptionSection: View {
    @Binding var caption: String
    let onTagPeople: () -> Void
    let onAddLocation: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // User info
            HStack {
                AsyncImage(url: URL(string: "https://example.com/current_user_avatar.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())

                Text("current_user")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            // Caption input
            VStack(alignment: .leading) {
                TextEditor(text: $caption)
                    .frame(minHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .overlay(
                        Group {
                            if caption.isEmpty {
                                VStack {
                                    HStack {
                                        Text("Write a caption...")
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        }
                    )

                // Additional options
                HStack(spacing: 20) {
                    Button(action: onTagPeople) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                            Text("Tag People")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }

                    Button(action: onAddLocation) {
                        HStack {
                            Image(systemName: "location")
                            Text("Add Location")
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }

                    Spacer()
                }
            }
        }
        .padding(16)
    }
}

@MainActor
class CreatePostViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""

    func loadImages(from items: [PhotosPickerItem]) async {
        selectedImages.removeAll()

        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImages.append(image)
            }
        }
    }

    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }

    func sharePost(caption: String) async {
        isLoading = true

        // Simulate upload
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        isLoading = false
        // Post shared successfully
    }

    func tagPeople() {
        // Show tag people interface
    }

    func addLocation() {
        // Show location picker
    }
}

#Preview {
    CreatePostScreen()
}