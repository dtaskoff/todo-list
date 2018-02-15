module Task where

import Foundation
import Types
import Yesod.Core


-- | A simple handler, that just outputs in the console the JSON body of the POST request
-- Note: requireJsonBody succeeds only if the passed JSON is correct, e.g. matches the
-- FromJSON instance for Task
postTaskR :: Handler ()
postTaskR = do
  task <- requireJsonBody
  liftIO $ print (task :: Task)
