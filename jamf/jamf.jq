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
    utc8601_to_epoch(.)
    ;

def utc2epoch(s):
    utc8601_to_epoch(s)
    ;

def utc8601_to_local8601(s):
    s 
    | sub("\\.\\d+Z?$";"Z")
    | fromdateiso8601
    | strflocaltime("%Y-%m-%dT%H:%M:%S%z") 
    ;

def utc2local(s):
    utc8601_to_local8601(s)
    ;

def utc2local:
    utc8601_to_local8601(.)
    ;

# //  
# //  

def local8601_to_utc8601(s):
    # // s  # // | sub("\\.\\d+Z?$";"Z")
    # // | fromdateiso8601
    # // | strflocaltime("%Y-%m-%dT%H:%M:%S%Z") 
    debug("[NOTICE] Have not figured out how to perform this conversion within jq yet.") | s
    ;

def local2utc(s):
    local8601_to_utc8601(s)
    ;

def local2utc:
    local8601_to_utc8601(.)
    ;


# //  
# //  
def epoch2local(t):
    if   t > (now|round)  # // 
    then (t/1000|round) 
    else t 
    end 
    | todateiso8601 
    | utc2local 
    ;

def epoch2local:
    epoch2local(.)
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

def days_ago(epoch_seconds):
    ( 
        (now-epoch_seconds) / 86400 # // sec = 60s * 60m * 24h 
        | round     # // decimals unnecessary
    ) as $days_ago
    | ($days_ago | tostring)  # // convert to string to allow appending strings next 
    + (if $days_ago!=1 then " days" else " day" end)
    + " ago"
    ;

def days_ago_iso8601(iso8601):
    (utc2epoch(iso8601)/86400) as $timestamp 
    | days_ago($timestamp)
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  NEEDS REORGANIZING                                                  │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Computers Inventory Lookup Helpers                                  │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def summarize_computers_inventory:
    debug(".|type == \"\(type)\"") |
    .results
    | map(
        {
            deviceId:         .id,
            name:             .general.name,
            managementId:     .general.managementId,
            lastContactEpoch:  utc2epoch(.general.lastContactTime),
            lastContactTime:   .general.lastContactTime,
            reportEpoch:       utc2epoch(.general.reportDate),
            reportDate:       .general.reportDate,
            osVersion:        .operatingSystem.version,
            modelIdentifier:  .hardware.modelIdentifier
        }
    )
    ;

# //
# // $cludb example:
# // [
# //    {
# //      "deviceId": "1637",
# //      "name": "coppee304-mac-1",
# //      "managementId": "e5bccf0f-32c4-4cc4-92a6-6de084f021bb",
# //      "version": "14.7.1"
# //    }
# // ]
# //

def clu_by_deviceid($cludb; $deviceId):
    # // jq --slurpfile cludb computers.json 'import "jamf" as j; .results|map( j::clu_by_deviceid(.device.deviceId) )'
    $cludb[][] 
    | select(.deviceId==$deviceId) 
    ;

def clu_by_managementid($cludb; $managementId):
    # // jq --slurpfile cludb computers.json 'import "jamf" as j; .results|map( j::clu_by_managementid(.managementUUID) )'
    $cludb[][] 
    | select(.managementId==$managementId) 
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  plan (ddm) declarations                                             │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def add_declarations_fromjson:
    if type=="object" and has("declarations") then
        .declarations | map( .payloadJson|=fromjson )
    elif type=="array" then
        .
    else
        empty
    end
    ;


def sanity_check($continue):
    debug("api path: \($the_path)") |

    if  # // $ref = #/components/schemas/ApiError
        ( type=="object" and has("errors") )
        # // example:
        # //    {
        # //      "httpStatus": 400,
        # //      "errors": [
        # //        {
        # //          "code": "INVALID_ID",
        # //          "description": "Managed Software Update Plan UUID, '0', is not in a proper UUID format.",
        # //          "id": "0",
        # //          "field": null
        # //        }
        # //      ]
        # //    }
    then 
        debug(
            "[ERROR] "
            + "return code: \(.httpStatus);" 
            + " error messages: \( if .errors|length>0 then (.errors|map([.code,.description]|join(" "))|join("; ")) else "(none)" end )"
            ) 
        | if $continue then . else empty end

    elif  # // Many responses follow pattern of { totalCount: integer, results: array }
          # //   but _not_ all (some return just an array)
        ( type=="object" and has("totalCount") and has("results") and (.totalCount!=(.results|length)) ) 
    then 
        debug("[WARNING] totalCount: \(.totalCount?), results: \(.results|length); Try with --url-query page-size=\(.totalCount)") 
        | if $continue then . else empty end

    else
        debug("[INFO] totalCount: \(.totalCount?), results: \(.results?|length)")
        | .

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
