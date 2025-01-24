# // Usage (ex):  jq 'import "jamf" as j; j::utc8601_to_epoch(.general.lastContactTime)'
# //   
# // ╭┬──────────────────────────────────────────────────────────────────────────╮
# // ││  ┏┓┏━┓┏┳┓┏━╸   ┏━┓┏━┓┏━┓   ┏━┓┏━┓╻   ┏━┓┏━╸╻ ╻┏━╸┏┳┓┏━┓   ╻ ╻╺┳╸╻╻  ┏━┓  │
# // ││   ┃┣━┫┃┃┃┣╸    ┣━┛┣┳┛┃ ┃   ┣━┫┣━┛┃   ┗━┓┃  ┣━┫┣╸ ┃┃┃┣━┫   ┃ ┃ ┃ ┃┃  ┗━┓  │
# // ││ ┗━┛╹ ╹╹ ╹╹     ╹  ╹┗╸┗━┛   ╹ ╹╹  ╹   ┗━┛┗━╸╹ ╹┗━╸╹ ╹╹ ╹   ┗━┛ ╹ ╹┗━╸┗━┛  │
# // ╰┴──────────────────────────────────────────────────────────────────────────╯
# //   
# //   
# //  ╭┬────────────────────────────╮
# //  ││  ╻ ╺┳╸┏━┓   ╺┳┓┏━┓╻┏━┓ ╻   │
# //  ││  ╻  ┃ ┃ ┃╺━╸ ┃┃┃ ┃ ┗━┓ ╹   │
# //  ││  ╹  ╹ ┗━┛   ╺┻┛┗━┛ ┗━┛ ╹   │
# //  ╰┴────────────────────────────╯
# //   
# //   1. group/name functions top-down purpose
# //      a. (ex) paths      --> 
# //              components --> 
# //   
# //   2. paths
# //      a. deprecated? when?
# //      b. required privs?
# //      c. 
# //   
# //   3. …
# //   
# //   4. …
# //   
# //  ╭┬────────────────────────────╮
# //  ╰┴────────────────────────────╯

# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Metadata                                                            │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯
# // jq -n '"jamf/schema/paths" | modulemeta'

module {
    "name": "paths",
    "deps": [],
    "defs": [
        "utc8601_to_epoch(s)",
        "utc8601_to_epoch",
        "utc8601_to_local8601(s)",
        "add_iso8601_localtime_from_iso8601_utc",
        "add_declarations_fromjson"
    ]
};


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  ISO 8601 timestamp utilities                                        │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def utc8601_to_epoch(s):
    s | strings | sub("\\.\\d+Z?$";"Z") | fromdateiso8601
    ;

def utc8601_to_epoch:
    . | strings | utc8601_to_epoch(.)
    ;

def utc8601_to_local8601(s):
    s | sub("\\.\\d+Z?$";"Z") | fromdateiso8601 | strflocaltime("%Y-%m-%dT%H:%M:%S%z") 
    ;

def add_iso8601_localtime_from_iso8601_utc:
    .results
    |= map(
            . += {
                dateSentLocal: utc8601_to_local8601(.dateSent?)
            }
            | if (.dateCompleted|test("^1970-")|not) then
                . += { dateCompletedLocal: utc8601_to_local8601(.dateCompleted) }
              end
        )
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  NEEDS REORGANIZING                                                  │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def add_declarations_fromjson:
    if type=="object" and has("declarations") then
        .declarations |= map( . += { _payloadFromJson: (.payloadJson|fromjson) } )
    else
        empty
    end
    ;


# // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# // - Needs fixing/refactoring …                                           -
# // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# // def differ($a; $b):
# //     ($a.statusItems|sort_by(.lastUpdateTime)|map(.value)) 
# //         - ($b.statusItems|sort_by(.lastUpdateTime)|map(.value)) as $x 
# //     | ($b.statusItems|sort_by(.lastUpdateTime)|map(.value)) 
# //         - ($a.statusItems|sort_by(.lastUpdateTime)|map(.value)) as $y 
# //     | [$x, $y]
# //     ;
