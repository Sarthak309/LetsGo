//
//  LocationSearchResultCell.swift
//  Let'sGo
//
//  Created by Sarthak Agrawal on 03/09/23.
//

import SwiftUI
import CoreLocation

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String

    var body: some View {
        HStack{
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(.blue)
                .accentColor(.white)
                .frame(width: 40, height: 40)
            
            
            VStack(alignment: .leading, spacing: 4){
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                Divider()
            }
            .padding(.leading, 8 )
            .padding(.vertical, 8)

        }
        .padding(.leading)
    }
}

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchResultCell(title: "StarBucks", subtitle: "123 Main Street ")
    }
}
