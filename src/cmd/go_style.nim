import tables
import os
import strformat

type
    Item = object
        v: ptr string
        desc: string
        has: bool

type
    Cmd = object
        help: string
        keys: tables.TableRef[string, Item]

proc newCmd*(): Cmd =
    Cmd(
        help: "--help",
        keys: tables.newTable[string, Item]()
    )

proc registerWithDesc*(self: var Cmd, key: string, default: string, desc: string): ptr string
proc printHelp(self: Cmd)
proc exit(self: Cmd)

proc register*(self: var Cmd, key: string, default: string): ptr string =
    self.registerWithDesc(key, default, "")

proc registerWithDesc*(self: var Cmd, key: string, default: string, desc: string): ptr string =
    var v = cast[ptr string](alloc0(sizeof(string)))
    v[] = default
    self.keys.add(key, Item(
        v: v,
        desc: desc,
        has: false
    ))
    v

proc has*(self: Cmd, key: string): bool =
    if key in self.keys:
        return self.keys[key].has
    else:
        return false

proc parse*(self: var Cmd) =
    let args = os.commandLineParams()
    let argsLen = args.len()
    var isFind = false
    var lastKey = ""
    for arg in args:
        if arg == self.help:
            self.printHelp()
            self.exit()
        if arg in self.keys:
            isFind = true
            lastKey = arg
            if lastKey in self.keys:
                self.keys[lastKey].has = true
        else:
            if isFind:
                if lastKey in self.keys:
                    self.keys[lastKey].v[] = arg.string
                    # echo(fmt"lastKey: {lastKey}, arg: {arg}")
            isFind = false

proc printHelp(self: Cmd) =
    echo("help:")
    for key, value in self.keys.pairs():
        echo("\t", key, "\n\t\tdefault: ", value.v[], "\n\t\tdesc: ", value.desc)

proc exit(self: Cmd) =
    discard os.exitStatusLikeShell(0)
