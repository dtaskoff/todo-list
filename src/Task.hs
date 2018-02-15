module Task where

import Data.List (find)
import Foundation
import Types
import Yesod.Core


getTaskR :: Handler Value
-- getTaskR = returnJson =<< getsYesod tasks
getTaskR = do
  tasks' <- getsYesod tasks
  returnJson tasks'

getTaskIDR :: Int -> Handler Value
-- getTaskIDR i = maybe notFound returnJson . find ((== i) . tid) =<< getsYesod tasks
getTaskIDR i = do
  tasks' <- getsYesod tasks
  let mtask = find ((== i) . tid) tasks'
  maybe notFound returnJson mtask
--  let mtask = find ((== i) . tid) tasks'
--  case mtask of
--    Just task -> returnJson task
--    Nothing   -> notFound

-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
