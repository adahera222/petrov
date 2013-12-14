module Components.Model where

(gameWidth,gameHeight) = (720,480)
(halfWidth,halfHeight) = (360,240)

data State = Alive

type Game = { state:State }

defaultGame =
  { state = Alive }
