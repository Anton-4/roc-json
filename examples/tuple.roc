app [main!] {
    cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/bi5zubJ-_Hva9vxxPq4kNx4WHX6oFs8OP6Ad0tCYlrY.tar.br",
    json: "../package/main.roc", # use release URL (ends in tar.br) for local example, see github.com/lukewilliamboswell/roc-json/releases
}

import cli.Stdout
import json.Json

main! = |_args|
    bytes = Str.to_utf8("[ [ 123,\n\"apples\" ], [  456,  \"oranges\" ]]")

    tuple : List FruitCount
    tuple = Decode.from_bytes(bytes, Json.utf8)?

    Stdout.line!("Successfully decoded tuple, got ${to_str(tuple)}")?

    Ok({})

FruitCount : (U32, Str)

to_str : List FruitCount -> Str
to_str = |fcs|
    fcs
    |> List.map(|(count, fruit)| "${fruit}:${Num.to_str(count)}")
    |> Str.join_with(", ")
