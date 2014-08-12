{-# LANGUAGE ForeignFunctionInterface #-}

foreign import ccall "x" x :: IO ()

main :: IO ()
main = x >> putStrLn "hstest done"
