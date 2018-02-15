{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE ViewPatterns      #-}
module Foundation where

import Control.Concurrent.MVar
import Task
import Yesod.Core


data App = App { nextIndex :: MVar Int
               , tasks :: MVar Tasks
               }

mkYesodData "App" $(parseRoutesFile "routes")

instance Yesod App

getTasksYesod :: Handler Tasks
-- getTasksYesod = liftIO . readMVar =<< getsYesod tasks
getTasksYesod = do
  tasksMVar <- getsYesod tasks
  liftIO $ readMVar tasksMVar

-- | Returns the next index and updates it (increments it by one)
getNextIndex :: Handler Int
getNextIndex = do
  nextIndexMVar <- getsYesod nextIndex
  liftIO $ modifyMVar nextIndexMVar (\i -> pure (i + 1, i))
