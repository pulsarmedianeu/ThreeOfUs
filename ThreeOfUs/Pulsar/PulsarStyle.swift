//  Created by Orszagh Sandor on 2022. 03. 27..
//
//  PulsarStyle
//
//
//

import Foundation
import SwiftUI

class PulsarStyle {

//----------------->
//--> Button Styles

    class Btn {
        
    //--> Filled Circle Button
        struct CircleFill : ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .frame(width:100,height:100)
                    .background(Color.red)
                    .foregroundColor(Color.black)
                    .clipShape(Circle())
                    
            }
        }
           
    //--> Stroked Rounded Button
        struct RoundedStroke : ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .frame(width: 100, height: 100, alignment: Alignment.center)
                    .font(.system(size: 18))
                    .padding()
                    .foregroundColor(.black)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.black, lineWidth: 2))
            }
        }
        
         
    //--> Image  Button
        
        struct ImageOver : ButtonStyle {
            func makeBody(configuration: Configuration) -> some View {
                configuration.label
                    .overlay(
                        Image(systemName: "pencil")
                            .resizable()
                            .aspectRatio(1, contentMode: ContentMode.fill)
                    )

            }
        }
    }
}

