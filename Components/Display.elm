module Components.Display where

import Components.Model (Game, gameWidth, gameHeight, halfWidth, halfHeight)

sceneBackground = rgb 15 15 15

display : (Int, Int) -> Game -> Element
display (w, h) {state} =
  container w h middle <| collage gameWidth gameHeight
    [ rect gameWidth gameHeight |> filled sceneBackground
    , rect (gameWidth - 60) halfHeight |> (filled <| rgb 0 0 0) |> moveY (halfHeight / 2 - 30)
    , polygon (path [(0, 0), (gameWidth - 60, 0), (gameWidth - 45, (-halfHeight / 2)), (-15, (-halfHeight / 2))])
        |> (filled <| rgb 31 31 31) |> move (-halfWidth + 30, -(halfHeight / 2) + 100)
    ]
