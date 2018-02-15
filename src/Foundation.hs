{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Types
import Yesod.Core


data App = App { tasks :: [Task] }

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App
