module Components.Display where

import Components.Model (Game, gameWidth, gameHeight, halfWidth, halfHeight)

sceneBackground = rgb 15 15 15

display : (Int, Int) -> Game -> Element
display (w, h) {state} =
  let
      background : Form
      background = rect gameWidth gameHeight |> filled sceneBackground

      alarm : Form
      alarm = oval 40 20 |> (filled <| rgb 98 2 2) |> moveY halfHeight

      worldMap : Form
      worldMap = rect (gameWidth - 60) halfHeight |> (filled <| rgb 0 0 0) |> moveY (halfHeight / 2 - 30)

      controlPanel : Form
      controlPanel = polygon (path [(0, 0), (gameWidth - 60, 0), (gameWidth - 45, (-halfHeight / 2)), (-15, (-halfHeight / 2))])
                      |> (filled <| rgb 31 31 31) |> move (-halfWidth + 30, -(halfHeight / 2) + 100)

  in collage gameWidth gameHeight [background, alarm, worldMap, controlPanel] |> container w h middle
