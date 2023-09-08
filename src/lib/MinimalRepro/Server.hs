module MinimalRepro.Server (run) where

import qualified Dotenv

run :: IO ()
run = do
  Dotenv.load

  server

server :: IO ()
server = putStrLn "Server is running on port 3000."
