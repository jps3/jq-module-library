# // Usage:  jq 'import "jamf/api/msu/plans" as plans; plans::funcname'
# // 
# // ╭┬───────────────────────────────────────────────────────────────────────╮
# // ││  ┏━┓╻  ┏━┓┏┓╻┏━┓                                                      │
# // ││  ┣━┛┃  ┣━┫┃┗┫┗━┓                                                      │
# // ││  ╹  ┗━╸╹ ╹╹ ╹┗━┛                                                      │
# // ╰┴───────────────────────────────────────────────────────────────────────╯

# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Metadata                                                            │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯
# // jq -n '"jamf/api/msu/plans" | modulemeta'

module {
    "name": "plans",
    "deps": [],
    "defs": [
        "add_timestamps"
    ]
};


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Deprecated                                                          │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def add_timestamps:
    .events | fromjson | .events
    | to_entries
    | map(
            .value
            | foreach .value as $event (
                .; 
                . += { 
                    eventEpochAsTimestamp: (
                        (
                            if   .eventSentEpoch?     then .eventSentEpoch 
                            elif .eventReceivedEpoch? then .eventReceivedEpoch 
                            else null 
                            end
                         )
                        /1000
                        | strftime("%Y-%m-%dT%H:%M:%SZ")
                    ),
                    eventEpochAsLocalTimestamp: (
                        (
                            if   .eventSentEpoch?     then .eventSentEpoch 
                            elif .eventReceivedEpoch? then .eventReceivedEpoch 
                            else null 
                            end
                         )
                        /1000
                        | strflocaltime("%Y-%m-%dT%H:%M:%S%z")
                    )
                }
              )
        )
    ;

