module Components.Display where

import Components.Model as Model

sceneBackground = rgb 15 15 15

render : (Int, Int) -> Model.Game -> Element
render (w, h) {state} =
  case state of
    Model.Alive -> renderGame w h

renderGame : Int -> Int -> Element
renderGame w h =
  let
      background : Form
      background = rect Model.gameWidth Model.gameHeight |> filled sceneBackground

      alarm : Form
      alarm = oval 40 20 |> (filled <| rgb 98 2 2) |> moveY Model.halfHeight

      worldMap : Form
      worldMap = rect (Model.gameWidth - 60) Model.halfHeight |> (filled <| rgb 0 0 0) |> moveY (Model.halfHeight / 2 - 30)

      controlPanel : Form
      controlPanel = polygon (path [(0, 0), (Model.gameWidth - 60, 0), (Model.gameWidth - 45, (-Model.halfHeight / 2)), (-15, (-Model.halfHeight / 2))])
                      |> (filled <| rgb 31 31 31) |> move (-Model.halfWidth + 30, -(Model.halfHeight / 2) + 100)

  in collage Model.gameWidth Model.gameHeight [background, alarm, worldMap, controlPanel] |> container w h middle
