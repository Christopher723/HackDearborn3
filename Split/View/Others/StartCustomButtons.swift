
import SwiftUI

struct StartCustomButtons: View {
    var role: String
    
    var body: some View {
        switch role {
        case "scan":
            Label("Scan", systemImage: "viewfinder")
                .font(.subheadline)
                .labelStyle(.titleAndIcon)
                .foregroundColor(Color("mBlue"))
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color("mYellow"))
                .clipShape(Capsule())

        case "library":
            Label("", systemImage: "photo.on.rectangle.angled")
                .font(.subheadline)
                .labelStyle(.iconOnly)
                .foregroundColor(Color("mBlue"))
                .padding(10)
                .background(Color("mYellow").opacity(0.15))
                .clipShape(Circle())
            
        case "files":
            Label("", systemImage: "folder")
                .font(.subheadline)
                .labelStyle(.iconOnly)
                .foregroundColor(Color("mBlue"))
                .padding(10)
                .background(Color("mYellow").opacity(0.15))
                .clipShape(Circle())


        default:
            EmptyView()
        }
    }
}

struct StartCustomButtons_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartCustomButtons(role: "scan")
            StartCustomButtons(role: "library")
            StartCustomButtons(role: "files")
        }
        .previewLayout(PreviewLayout.sizeThatFits)
        .padding()
        .previewDisplayName("Default preview")
    }
}
