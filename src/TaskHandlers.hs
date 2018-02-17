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

-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler Value
postTaskR = do
  taskPOST <- requireJsonBody
  i <- getNextIndex
  let task = createTaskFromPOST i taskPOST

  tasksMVar <- getsYesod tasks
  liftIO $ modifyMVar_ tasksMVar (pure . addTask task)
  returnJson task

getTaskIDR :: Int -> Handler Value
getTaskIDR i = do
  mtask <- runDB $ getBy $ TaskID i
  maybe notFound (returnJson . entityTaskToTask) mtask

deleteTaskIDR :: Int -> Handler Value
deleteTaskIDR i = do
  tasksMVar <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasksMVar (pure . removeTask i)
  maybe notFound returnJson mtask

putTaskIDR :: Int -> Handler Value
putTaskIDR i = do
  tasks' <- getTasksYesod

  case find (matchesID i) tasks' of
    Nothing -> notFound
    Just task -> do
      taskPUT <- requireJsonBody
      tasksMVar <- getsYesod tasks

      liftIO $ modifyMVar_ tasksMVar $
        pure . addTask (updateTask task taskPUT) . fst . removeTask i
        -- ^ updating a task is the same as removing it and then inserting the updated version of it
        -- (not really efficient, though)

      returnJson task
