module Paths_ygit (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/mjoseph/tech/haskell/ygit/.cabal-sandbox/bin"
libdir     = "/Users/mjoseph/tech/haskell/ygit/.cabal-sandbox/lib/x86_64-osx-ghc-7.8.3/ygit-0.1.0.0"
datadir    = "/Users/mjoseph/tech/haskell/ygit/.cabal-sandbox/share/x86_64-osx-ghc-7.8.3/ygit-0.1.0.0"
libexecdir = "/Users/mjoseph/tech/haskell/ygit/.cabal-sandbox/libexec"
sysconfdir = "/Users/mjoseph/tech/haskell/ygit/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "ygit_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "ygit_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "ygit_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "ygit_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "ygit_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
