{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE MultiParamTypeClasses #-}
module Internal.RestrictedIO (
    RestrictedIO
    , UnsafeFileIO(..)
    , EntropyIO(..)
) where

import Data.Kind

import Internal.Untrusted

type RestrictedIO m entropy = (UnsafeFileIO m, EntropyIO m entropy)

class UnsafeFileIO (m :: Type -> Type) where
    -- | read a file from an untrusted part of the filesystem, yielding an untrusted
    -- Value
    untrustedReadFile  :: FilePath -> m (Untrusted String)
    -- | write to the untrusted part of the filesystem. This is identical to the
    -- conventional @readFile@ function
    untrustedwriteFile :: FilePath -> String -> m ()

class EntropyIO (m :: Type -> Type) (entropy :: Type) where
    genEntropyPool :: m entropy
