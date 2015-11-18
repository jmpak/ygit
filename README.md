# ygit

This is Haskell implementation of git. 

## Installation:
    ???

## List of implemented commands:

## [count objects](https://git-scm.com/docs/git-count-objects)

  Count unpacked number of objects and their disk consumption.

    ygit count-objects

### Supported options:  
    ???

## [hash objects](https://git-scm.com/docs/git-hash-object)

  Compute object ID and optionally creates a blob from a file.

    ygit [-w] hash-object thefile

### Supported options:  

    [-w] - Actually write the object into the object database.


## [ls-files](https://git-scm.com/docs/git-ls-files)
  Show information about files in the index and the working tree

    cabal run ls-files


### Supported options:
    ???  


## Build and run

```sh
cabal build
```

```sh
cabal run count-objects
```
