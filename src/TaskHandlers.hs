module TaskHandlers where

import Control.Concurrent.MVar
import Database.Persist
import Data.List (find)
import Foundation
import Task
import TaskPOST
import TaskPUT
import Yesod.Core
import Yesod.Persist


getTaskR :: Handler Value
getTaskR = do
  tasks' <- runDB $ selectList [] []
  returnJson $ map entityTaskToTask (tasks' :: [Entity Task])

-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler Value
postTaskR = do
  taskPOST <- requireJsonBody
  i <- getNextIndex
  let task = taskPOSTToTask i taskPOST
  runDB $ insert task
  returnJson task

getTaskIDR :: Int -> Handler Value
getTaskIDR i = do
  mtask <- runDB $ getBy $ TaskID i
  maybe notFound (returnJson . entityTaskToTask) mtask

deleteTaskIDR :: Int -> Handler Value
deleteTaskIDR i = do
  mtask <- runDB $ do
    res <- getBy $ TaskID i
    deleteBy $ TaskID i
    pure res
  maybe notFound returnJson mtask

putTaskIDR :: Int -> Handler Value
putTaskIDR i = do
  taskPUT <- requireJsonBody
  mtask <- runDB $ do
    mentity <- getBy $ TaskID i
    case mentity of
      Nothing -> pure Nothing
      Just (Entity key value) -> do
        update key $ taskPUTToUpdates taskPUT
        pure $ Just value

  maybe notFound returnJson mtask
