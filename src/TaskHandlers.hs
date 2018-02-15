module TaskHandlers where

import Control.Concurrent.MVar
import Data.List (find)
import Foundation
import Task
import Yesod.Core


getTasksYesod :: Handler Tasks
-- getTasksYesod = liftIO . readMVar =<< getsYesod tasks
getTasksYesod = do
  tasksMVar <- getsYesod tasks
  liftIO $ readMVar tasksMVar

getTaskR :: Handler Value
-- getTaskR = returnJson =<< getTasksYesod
getTaskR = do
  tasks' <- getTasksYesod
  returnJson tasks'

getTaskIDR :: Int -> Handler Value
-- getTaskIDR i = maybe notFound returnJson . find (matchesID i) =<< getTasksYesod
getTaskIDR i = do
  tasks' <- getTasksYesod
  let mtask = find (matchesID i) tasks'
  maybe notFound returnJson mtask
--  case mtask of
--    Just task -> returnJson task
--    Nothing   -> notFound

-- | Returns the next index and updates it (increments it by one)
getNextIndex :: Handler Int
getNextIndex = do
  nextIndexMVar <- getsYesod nextIndex
  liftIO $ modifyMVar nextIndexMVar (\i -> pure (i + 1, i))

deleteTaskIDR :: Int -> Handler Value
deleteTaskIDR i = do
  tasksMVar <- getsYesod tasks
  mtask <- liftIO $ modifyMVar tasksMVar (pure . removeTask i)
  maybe notFound returnJson mtask

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
