module Components.Input where

import Graphics.Input (customButton)

import Keyboard

type Input = { space: Bool
             , enter: Bool
             , elapsed: Time
             }

delta = inSeconds <~ fps 35
input = sampleOn delta (Input <~ Keyboard.space
                               ~ Keyboard.enter
                               ~ every second)
