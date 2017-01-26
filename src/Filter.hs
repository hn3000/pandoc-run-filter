module Filter where

import Text.Pandoc.JSON
import Text.Pandoc.Definition
import System.Process

filterMain = toJSONFilter runcmd

runcmd :: Block -> IO Block
runcmd cb@(CodeBlock (id, classes, namevals) contents)
  | classes == ["run","bash"]  =
    return . CodeBlock ("", [], []) =<< (readProcess "bash" [ "-c", contents ] [])
  | classes == ["run", "node"]  =
    return . CodeBlock ("", [], []) =<< (readProcess "node" [ "-p", contents ] [])
  | otherwise = return cb
runcmd x = return x
