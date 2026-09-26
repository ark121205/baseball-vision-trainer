
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct VideoPickerView: UIViewControllerRepresentable {
    let onPicked: (URL, String) -> Void
    let onCancel: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onPicked: onPicked, onCancel: onCancel)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .videos
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: Context
    ) {}

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPicked: (URL, String) -> Void
        let onCancel: () -> Void

        init(
            onPicked: @escaping (URL, String) -> Void,
            onCancel: @escaping () -> Void
        ) {
            self.onPicked = onPicked
            self.onCancel = onCancel
        }

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            picker.dismiss(animated: true)

            guard let result = results.first else {
                onCancel()
                return
            }

            let provider = result.itemProvider
            let movieType = UTType.movie.identifier

            guard provider.hasItemConformingToTypeIdentifier(movieType) else {
                onCancel()
                return
            }

            provider.loadFileRepresentation(
                forTypeIdentifier: movieType
            ) { [weak self] sourceURL, error in

                guard
                    let self,
                    let sourceURL,
                    error == nil
                else {
                    DispatchQueue.main.async {
                        self?.onCancel()
                    }
                    return
                }

                do {
                    let fm = FileManager.default
                    let ext = sourceURL.pathExtension.isEmpty
                        ? "mov"
                        : sourceURL.pathExtension

                    let filename = sourceURL.lastPathComponent.isEmpty
                        ? "selected-video.\(ext)"
                        : sourceURL.lastPathComponent

                    let destination = fm.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension(ext)

                    if fm.fileExists(atPath: destination.path) {
                        try fm.removeItem(at: destination)
                    }

                    try fm.copyItem(at: sourceURL, to: destination)

                    DispatchQueue.main.async {
                        self.onPicked(destination, filename)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onCancel()
                    }
                }
            }
        }
    }
}
