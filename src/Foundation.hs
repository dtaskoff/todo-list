{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Control.Concurrent.MVar
import Task
import Yesod.Core

data App = App { tasks :: MVar [Task] }

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App
