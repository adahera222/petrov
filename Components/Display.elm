module Components.Display where

import Components.Model as Model

sceneBackground = rgb 15 15 15

styleText : Color -> number -> String -> Element
styleText fg h v = toText v |> text . Text.color fg . Text.height h . monospace

render : (Int, Int) -> Model.Game -> Element
render (w, h) {state, timer} =
  case state of
    Model.StartScreen -> renderStartScreen w h
    Model.Alive -> renderGame w h timer

renderStartScreen : Int -> Int -> Element
renderStartScreen w h =
  let
      background : Form
      background = rect Model.gameWidth Model.gameHeight |> filled sceneBackground

      welcomeText : Form
      welcomeText = styleText (rgb 160 0 0) 42 "Petrov's Decision" |> toForm |> moveY (Model.halfHeight - 50)

      startText : Form
      startText = styleText (rgb 220 220 220) 16 "Press [SPACE] to man your post" |> toForm |> moveY (-Model.halfHeight + 24)

  in collage Model.gameWidth Model.gameHeight [background, welcomeText, startText] |> container w h middle

renderGame : Int -> Int -> Int -> Element
renderGame w h timer =
  let
      background : Form
      background = rect Model.gameWidth Model.gameHeight |> filled sceneBackground

      alarm : Form
      alarm = oval 40 20 |> (filled <| rgb 98 2 2) |> moveY Model.halfHeight

      worldMap : Form
      worldMap = rect (Model.gameWidth - 60) Model.halfHeight |> (filled <| rgb 0 0 0) |> moveY (Model.halfHeight / 2 - 30)

      controlPanel : Form
      controlPanel = [ polygon (path [(0, 0), (Model.gameWidth - 60, 0), (Model.gameWidth - 45, (-Model.halfHeight / 2)), (-15, (-Model.halfHeight / 2))])
                         |> (filled <| rgb 31 31 31) |> move (-Model.halfWidth + 30, -(Model.halfHeight / 2) + 100)
                     , rect 30 20 |> (filled <| rgb 0 0 0) |> move (-Model.gameWidth / 4, -Model.gameHeight / 4)
                     , styleText (rgb 0 255 0) 14 (show timer) |> toForm |> move (-Model.gameWidth / 4, -Model.gameHeight / 4)
                     ] |> group

  in collage Model.gameWidth Model.gameHeight [background, alarm, worldMap, controlPanel] |> container w h middle
