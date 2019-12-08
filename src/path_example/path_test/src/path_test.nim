import "../../../path/vertical_walk"
import "../../../path/horizontal_walk"
import strformat

proc vertical_walk_test() =
    proc fn(parent: string, name: string, path: string): vertical_walk.CbResult =
        echo(fmt"parent: {parent}, name: {name}, path: {path}")
        result = vertical_walk.CbResult.Continue
    vertical_walk.walk("../..", fn)

proc horizontal_walk_test() =
    proc fn(parent: string, name: string, path: string): horizontal_walk.CbResult =
        echo(fmt"parent: {parent}, name: {name}, path: {path}")
        result = horizontal_walk.CbResult.Continue
    horizontal_walk.walk("../../..", fn)

when isMainModule:
    # vertical_walk_test()
    horizontal_walk_test()
