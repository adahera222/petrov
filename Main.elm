import Window

import Components.Model (Game, defaultGame)
import Components.Display (display)

-- Inputs

type Input = { delta: Time }

delta = inSeconds <~ fps 35

input = sampleOn delta (Input <~ delta)

-- Updates

stepGame : Input -> Game -> Game
stepGame {delta} ({state} as game) = game

gameState = foldp stepGame defaultGame input

main = lift2 display Window.dimensions gameState
