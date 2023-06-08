module Main where

import qualified Control.Concurrent as C
import Control.Exception (catch)
import Control.Monad (void)
import qualified Network.Socket as I
import qualified Network.Socket as S
import qualified System.IO as I
import qualified System.IO.Error as E

defaultListenAddr :: S.HostAddress
defaultListenAddr = S.tupleToHostAddress (0, 0, 0, 0)

net :: IO ()
net = do
  sock <- S.socket S.AF_INET S.Stream S.defaultProtocol
  S.setSocketOption sock S.ReuseAddr 1
  S.bind sock (S.SockAddrInet 8000 defaultListenAddr)
  addr <- S.getSocketName sock
  putStrLn $ "Listening on " <> show addr
  S.listen sock 2
  runLoop sock

runLoop :: S.Socket -> IO ()
runLoop sock = do
  (client, addr) <- S.accept sock
  putStrLn $ "Client connected at " <> show addr
  handle <- I.socketToHandle client I.ReadWriteMode
  I.hSetBuffering handle I.NoBuffering
  C.forkIO (runEcho handle)
  runLoop sock

runEcho :: I.Handle -> IO ()
runEcho handle = do
  str <- I.hGetLine handle
  I.hPutStrLn handle str
  runEcho handle

main :: IO ()
main = net
