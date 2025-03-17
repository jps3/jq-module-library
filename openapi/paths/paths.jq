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
        "get_deprecated",
        "del_non_deprecated",
        "del_deprecated",
        "mark_deprecated",
        "summarize_deprecated_paths",
        "list_operation_ids",
        "paths_tags",
        "paths_tags_like(like)",
        "paths_group_by_tag",
        "paths_group_by_tags_like(like)",
        "paths_with_tag($tag)",
        "paths_with_tag_list($tag)",
        "paths_like(like; mark_p; del_deprecated_p)",
        "paths_like(like)",
        "path_get(p)",
        "path_get(p; del_deprecated_p)",
        "paths_list",
        "_get_privs_for_paths",
        "get_privs_for_paths_with_tag_list($tag)",
        "get_privs_for_paths_like(like)"    
    ]
};


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  primary filters                                                     │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯
# //  
# //  Do we need or want a common (set of?) filters as an attempt to ensure
# //    that we are operating appropritaely on just the .paths top-level 
# //    component?
# //  
# //  If so, how would this be accomplished?
# //  


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Deprecated Paths                                                    │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯
# //  
# //  Q: Are _paths_ deprecated or a path’s _methods_?
# //  
# //  What do you want to do?
# //  - clean up and make consistent how initial detection occurs (object? array?)
# //  - filter to remove deprecated paths
# //  - filter to mark deprecated paths
# //  - filter to remove non-deprecated paths
# //  
# //  
# //   . as $doc| (paths|select( last=="deprecated" and first=="paths" ))|@tsv
# //  
# //   paths  /auth                                                 get     deprecated
# //   paths  /auth/current                                         post    deprecated
# //   paths  /auth/invalidateToken                                 post    deprecated
# //   paths  /auth/keepAlive                                       post    deprecated
# //   paths  /inventory-preload                                    get     deprecated
# //   paths  /inventory-preload                                    post    deprecated
# //   paths  /inventory-preload                                    delete  deprecated
# //   paths  /inventory-preload/csv-template                       get     deprecated
# //   paths  /inventory-preload/history                            get     deprecated
# //   paths  /inventory-preload/history/notes                      post    deprecated
# //  

def get_deprecated:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | with_entries(
        select( if (.value[].deprecated?==true|not) then empty end )
        )
    ;
def del_non_deprecated:
    get_deprecated
    ;


def del_deprecated:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | with_entries(
        select( if .value[].deprecated?==true then . end )
        )
    ;

def mark_deprecated:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
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

def summarize_deprecated_paths:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | get_deprecated 
    | debug("[INFO] identified \(length) deprecated paths") 
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
# //  ││  operationIds                                                        │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def list_operation_ids:
    debug("+ list_operation_ids not implemented yet")
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Tags                                                                │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def paths_tags:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | [ .. | objects | select(has("tags")) | .tags | add ] 
    | sort 
    | unique 
    ;

# // def list_tags:
# //   paths_tags[] 
# //   ;

def paths_tags_like(like):
    paths_tags 
    | map(select( . | test(like//"";"i") )) 
    | .[] 
    ;

def paths_group_by_tag:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
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

def paths_group_by_tags_like(like):
    paths_group_by_tag 
    | with_entries(select( .key | test(like//"jamf-pro-information") ))
    ;

def paths_with_tag($tag):
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | with_entries( select( .value[].tags? | arrays | .[] | IN($tag) ) )
    ;

def paths_with_tag_list($tag):
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | paths_with_tag($tag) 
    | keys  
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Path Utilities                                                      │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯

def paths_like(like; mark_p; del_deprecated_p):
    debug("++ paths_like(\(like); \(mark_p); \(del_deprecated_p))") |
    .paths 
    | with_entries(select(.key|test(like))) 
    | (if mark_p then .|mark_deprecated elif del_deprecated_p then .|del_deprecated else . end)
    ;

def paths_like(like):
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | with_entries(select(.key|test(like))) 
    ;

def path_get(p):
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | with_entries(select( .key == p )) 
    | if type=="array" then first else . end 
    ;

def path_get(p; del_deprecated_p):
    path_get(p) 
    | if del_deprecated_p  then del_deprecated  end 
    | select(.!={}) 
    ;

def paths_list:
    ( objects | if has("paths") then .paths else . end ) 
    # // 
    | keys[]    
    ;


# //  ╭┬──────────────────────────────────────────────────────────────────────╮
# //  ││  Privileges                                                          │
# //  ╰┴──────────────────────────────────────────────────────────────────────╯


def _get_privs_for_paths:
    if type=="object" then . else debug("_get_privs_for_paths expects a paths object (received: \(type))")|empty end
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


def get_privs_for_paths_with_tag_list($tag):
    paths_with_tag_list($tag) 
    | .[] 
    | _get_privs_for_paths 
    ;


def get_privs_for_paths_like(like):
    paths_like(like) 
    | _get_privs_for_paths 
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
# //     doc.paths | paths_group_by_tag
# //     ;


# // def paths_with_tag_list(tag; deprecated_p):
# //     . 
# //     | paths_group_by_tag
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;


# // def paths_with_tag_list(doc; tag):
# //     get_all_tags_with_paths(doc) 
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;


# // def paths_with_tag_list(tag):
# //     paths_group_by_tag(.) 
# //     | to_entries 
# //     | map(
# //         select( .key==tag ) 
# //         ) 
# //     | from_entries 
# //     ;

