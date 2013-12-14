import Window

import Components.Model as Model
import Components.Display as Display

-- Inputs

type Input = { delta: Time }

delta = inSeconds <~ fps 35

input = sampleOn delta (Input <~ delta)

-- Updates

stepGame : Input -> Model.Game -> Model.Game
stepGame {delta} ({state} as game) = game

gameState = foldp stepGame Model.defaultGame input

main = lift2 Display.render Window.dimensions gameState
