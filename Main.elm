import Window

import Components.Model as Model
import Components.Display as Display

main = lift2 Display.render Window.dimensions Model.gameState
