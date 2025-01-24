# // ╭┬───────────────────────────────────────────────────────────────────────╮
# // ││   ┏━┓┏━┓╺┳╸╻ ╻┏━┓                                                     │
# // ││   ┣━┛┣━┫ ┃ ┣━┫┗━┓                                                     │
# // ││  ╹╹  ╹ ╹ ╹ ╹ ╹┗━┛                                                     │
# // ╰┴───────────────────────────────────────────────────────────────────────╯

# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Metadata                                                            │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯
# // jq -n '"jamf/schema/paths" | modulemeta'

module {
    "name": "paths",
    "deps": [],
    "defs": [
        "del_deprecated",
        "mark_deprecated",
        "list_deprecated_paths_info",
        "get_tags",
        "list_tags",
        "tags_like(like)",
        "group_paths_by_tag",
        "group_paths_by_tag(like)",
        "paths_with_tag($tag)",
        "paths_like(like)",
        "get_path(p)",
        "get_path(p; del_deprecated_p)",
        "get_privs_for_path(like)",
        "summarize_paths",
        "get_all_tags_with_paths(doc)",
        "paths_with_tag(tag; deprecated_p)",
        "paths_with_tag(doc; tag)",
        "paths_with_tag(tag)"
    ]
};


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Deprecated                                                          │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def del_deprecated:
    .
    | objects 
    | with_entries(
        select(
            if .value[].deprecated?==true then empty else . end
            )
        )
    ;

def mark_deprecated:
    . 
    | objects 
    | to_entries
    | map(
        .value[]."x-deprecation-date"? as $x |
        if   .value[].deprecated?==true 
        then .key |= . + " [DEPRECATED:\($x)]"
        else . 
        end 
        ) 
    | from_entries 
    ;

def list_deprecated_paths_info:
    .paths
    | with_entries(select( .value[].deprecated?==true )) 
    | to_entries 
    | map(
            .key as $path 
            | .value 
            | to_entries
            | map(
                    select(.key|IN("delete", "get", "patch", "post", "put"))
                    | .key as $method
                    | { 
                        $path, 
                        $method, 
                        deprecation_date: (.value."x-deprecation-date"),
                        tags: (if .value.tags? then .value.tags|first else null end)
                      }
              )
              []
        )
    | sort_by(.deprecation_date)
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Tags                                                                │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def get_tags:
    if   type=="object" and has("paths") 
         then .paths 
    elif type=="object" 
         then . 
    else empty 
    end 
    | [ .. | objects | select(has("tags")) | .tags | add ] 
    | sort 
    | unique 
    ;

def list_tags:
    get_tags[] 
    ;

def tags_like(like):
    get_tags 
    | map(select( . | test(like//"";"i") )) 
    | .[] 
    ;

def group_paths_by_tag:
    if   type=="object" and has("paths") 
         then .paths 
    elif type=="object" 
         then . 
    else empty 
    end 
    | mark_deprecated 
    | to_entries 
    | map( 
        .key as $path 
        | .value 
        | to_entries 
        | map( 
            .value 
            | objects 
            | .tags
            )
        | flatten 
        | unique 
        | first 
        | { $path, tag: . } 
        )
    | reduce .[] as {$path, $tag} ({}; .[$tag]+=[$path])
    ;

def group_paths_by_tag(like):
    group_paths_by_tag 
    | with_entries(select( .key | test(like//"jamf-pro-information") ))
    ;

def paths_with_tag($tag):
    if   type=="object" and has("paths") 
         then .paths 
    elif type=="object" 
         then . 
    else empty 
    end 
    | mark_deprecated 
    | to_entries 
    | map( 
        .key as $path 
        | .value[] 
        | select( .tags? | index($tag) )
        | { $tag, $path } 
        )
    | reduce .[] as {$path, $tag} ({}; .[$tag]+=[$path])
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Path Utilities                                                      │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def paths_like(like):
    .paths 
    | with_entries(select(.key|test(like))) 
    | mark_deprecated 
    | keys_unsorted 
    | .[]
    ;

def get_path(p):
    if type=="object" and has("paths") then .paths else . end 
    | with_entries(select( .key == p )) 
    | if type=="array" then first else . end 
    ;

def get_path(p; del_deprecated_p):
    get_path(p) 
    | if del_deprecated_p  then del_deprecated  end 
    | select(.!={}) 
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Privileges                                                          │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def get_privs_for_path(like):
    .paths | with_entries(select( .key|test(like) ))
    | to_entries
    | map(
            .key as $path
            | .value
            | to_entries
            | map(
                    select(.key|IN("delete", "get", "patch", "post", "put"))
                    | .key as $method
                    | .value
                    | objects 
                    | select(has("responses") and has("x-required-privileges"))
                    | ."x-required-privileges" as $privs
                    | {$path, $method, $privs}
              )
     )
    | flatten 
    | reduce .[] 
        as {$path, $method, $privs} 
        ( {}; .[$path][$method] += $privs )
    ;


# // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# // - Needs fixing/refactoring …                                           -
# // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# //def summarize_paths:
# //    debug("[This function is not useful at this time]") |
# //    . as $doc 
# //    | .paths 
# //    | del_deprecated 
# //    | to_entries 
# //    | map(
# //        .key as $path 
# //        | .value 
# //        | to_entries 
# //        | map(
# //            .key as $method 
# //            | .value 
# //            | to_entries 
# //            | map(
# //                .key as $wtf 
# //                | .value 
# //                | {
# //                    $method,
# //                    $path,
# //                    $wtf,
# //                    type: (.|type),
# //                    "x-fuck": (if type=="object" then keys_unsorted|join("|") else empty end)
# //                  }
# //                )
# //            )
# //        ) 
# //    | flatten 
# //    | group_by(.path, .method)
# //    ;


# // def get_all_tags_with_paths(doc):
# //     doc.paths | group_paths_by_tag
# //     ;


# // def paths_with_tag(tag; deprecated_p):
# //     . 
# //     | group_paths_by_tag
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;


# // def paths_with_tag(doc; tag):
# //     get_all_tags_with_paths(doc) 
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;


# // def paths_with_tag(tag):
# //     group_paths_by_tag(.) 
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;

