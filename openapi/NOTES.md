# openapi

## TODOs

- Use an env var like JQ_DEBUG as flag to de-/activate `debug(...)` function calls?
- Looking at example CrowdStrike API (`.swagger`==`"2.0"`) swagger file it does not follow the same structural pattern as the Jamf Pro API (`.openapi`==`"3.0.1"`) swagger file.
    - assumptions about hierarchical structure cannot be assumed >:-/
    


## Ideas

- (root)
    - 

- paths
    - list paths like …
    - get path …
    - mark paths in results with …
        - `deprecated` (bool) [x-deprecation-date(string)]
        - `x-action`
        - `x-authentication-required`
        - `x-rate-limit` _(appears to only be for a few paths’ post methods)_
            - `/v1/accounts`
            - `/v1/managed-software-updates/plans`
            - `/v1/managed-software-updates/plans/group`
            - `/v1/user/change-password`
        - `x-required-privileges`
    - delete paths from results with …
        - `deprecated`
    - tags
        - group by tag
        - paths with tag
- schema file summary report



## paths

| `-` | ``get_path_summary(path)`` | ````` |
"/v1/managed-software-updates" 

get
    «deprecated»                 (bool)             *** <== ***
    «x-deprecation-date»         (string)           *** <== ***
    «tags»                       (array of string)
    «summary»                    (string)
    «description»                (string)
    «parameters»                 (object)
    «responses»                  (object)
    «security»                   (?)
    «x-authentication-required»  (bool)
    «x-action»                   (bool)
    «x-required-privileges»      (array of string)
    «x-rate-limit»               ?
    «operationId»                (string?)
    «requestBody»                (object) -- only used with post, put, patch, and delete methods (_not_ get)

| ````` | ````json` | `{` |
  "deprecated": 105,
  "description": 706,
  "operationId": 11
  "parameters": 436,
  "requestBody": 247,
  "responses": 706,
  "security": 11,
  "summary": 706,
  "tags": 706,
  "x-action": 102,
  "x-authentication-required": 70,
  "x-deprecation-date": 105,
  "x-rate-limit": 4,
  "x-required-privileges": 646,
}
| ````` | `###` | ``x-rate-limit`` |

| path                                       | method | x-rate-limit |
|--------------------------------------------|--------|--------------|
| `/v1/accounts`                             | `post` | `false`      |
| `/v1/managed-software-updates/plans`       | `post` | `true`       |
| `/v1/managed-software-updates/plans/group` | `post` | `true`       |
| `/v1/user/change-password`                 | `post` | `false`      |


### `operationId`

| path                                           | method   | operationId                   |
|------------------------------------------------|----------|-------------------------------|
| `/v1/api-integrations`                         | `post`   | `postCreateApiIntegration`    |
| `/v1/api-integrations/{id}`                    | `get`    | `getOneApiIntegration`        |
| `/v1/api-integrations/{id}`                    | `put`    | `putUpdateApiIntegration`     |
| `/v1/api-integrations/{id}`                    | `delete` | `deleteApiIntegration`        |
| `/v1/api-integrations/{id}/client-credentials` | `post`   | `postCreateClientCredentials` |
| `/v1/api-roles`                                | `get`    | `getAllApiRoles`              |
| `/v1/api-roles`                                | `post`   | `postCreateApiRole`           |
| `/v1/api-roles/{id}`                           | `get`    | `getOneApiRole`               |
| `/v1/api-roles/{id}`                           | `put`    | `putUpdateApiRole`            |
| `/v1/api-roles/{id}`                           | `delete` | `deleteApiRole`               |
| `/v1/oauth/token`                              | `post`   | `postOAuthToken`              |


### Deprecations

- how to detect and deal with specific path + method deprecations not just path?
- what about components
- how long are deprecations kept in the spec?

| `_Reduce` | `of` | `x-deprecation-dates_` |
```json
| `{` | `"2017-04-26":` | `1,` |
  "2020-01-01": 10,
  "2020-04-03": 5,
  "2020-04-07": 18,
  "2020-04-21": 3,
  "2020-04-22": 1,
  "2020-04-23": 2,
  "2020-04-24": 4,
  "2020-06-01": 4,
  "2020-08-02": 9,
  "2020-12-14": 3,
  "2021-01-04": 2,
  "2021-11-07": 2,
  "2022-03-16": 1,
  "2022-03-18": 1,
  "2022-03-30": 5,
  "2022-04-19": 7,
  "2022-10-17": 1,
  "2022-12-14": 1,
  "2023-01-18": 4,
  "2023-03-17": 5,
  "2023-04-25": 2,
  "2023-10-16": 2,
  "2023-12-06": 2,
  "2024-03-19": 2,
  "2024-09-01": 8
| `}` | ````` | ````json` |
| `{` | `"2017":` | `1,` |
  "2020": 59,
  "2021": 4,
  "2022": 16,
  "2023": 15,
  "2024": 10
| `}` | ````` | ````json` |
| `{` | `"2017-04":` | `1,` |
  "2020-01": 10,
  "2020-04": 33,
  "2020-06": 4,
  "2020-08": 9,
  "2020-12": 3,
  "2021-01": 2,
  "2021-11": 2,
  "2022-03": 7,
  "2022-04": 7,
  "2022-10": 1,
  "2022-12": 1,
  "2023-01": 4,
  "2023-03": 5,
  "2023-04": 2,
  "2023-10": 2,
  "2023-12": 2,
  "2024-03": 2,
  "2024-09": 8
}
```


- - - 

- "/api/path/name"
  - "get", "post", _etc_ (Request Method)
    - `deprecated` _boolean_
    - `description` _string_
    - `operationId` _string_ (see example table below)
    - `parameters` _array_ (of _object_)
    - `requestBody` 
    - `responses`
        - "200", "201", "202", "204", "400", "401", "403", "404", "409", "410", "412", "413", "414", "415", "422", "429", "500", "503"
    - `security`
        - `$ref`
            - `"#/components/schemas/ComputerSecurity"` _string_
            - `"#/components/schemas/MobileDeviceSecurity"`
            - `"#/components/schemas/SecurityV2"`
        - `ApiClient` _array_
        - `BasicAuth` _array_
            - ex. `"/v1/auth/token"` _string_
        - `Bearer` _array_
    - `summary` _string_
    - `tags` _array_
        - ex. `"managed-software-updates"` _string_
    - `x-action` _boolean_
    - `x-authentication-required` _boolean_
    - `x-deprecation-date` _string_
        - ex. `"2024-09-01"` _string
    - `x-rate-limit` _boolean_
    - `x-required-privileges` _array_
        - ex. `"Read Smart Computer Groups"` _string_

| `###` | `Operation` | `IDs` |

| path                                           | operationId                   |
|------------------------------------------------|-------------------------------|
| `/v1/api-integrations`                         | `postCreateApiIntegration`    |
| `/v1/api-integrations/{id}`                    | `getOneApiIntegration`        |
| `/v1/api-integrations/{id}`                    | `putUpdateApiIntegration`     |
| `/v1/api-integrations/{id}`                    | `deleteApiIntegration`        |
| `/v1/api-integrations/{id}/client-credentials` | `postCreateClientCredentials` |
| `/v1/api-roles`                                | `getAllApiRoles`              |
| `/v1/api-roles`                                | `postCreateApiRole`           |
| `/v1/api-roles/{id}`                           | `getOneApiRole`               |
| `/v1/api-roles/{id}`                           | `putUpdateApiRole`            |
| `/v1/api-roles/{id}`                           | `deleteApiRole`               |
| `/v1/oauth/token`                              | `postOAuthToken`              |


### Methods

| path                                                                                                                   | methods                 |
|------------------------------------------------------------------------------------------------------------------------|-------------------------|
| `/auth`                                                                                                                | `get`                   |
| `/auth/current`                                                                                                        | `post`                  |
| `/auth/invalidateToken`                                                                                                | `post`                  |
| `/auth/keepAlive`                                                                                                      | `post`                  |
| `/devices/extensionAttributes`                                                                                         | `get`                   |
| `/inventory-preload`                                                                                                   | `get,post,delete`       |
| `/inventory-preload/csv-template`                                                                                      | `get`                   |
| `/inventory-preload/history`                                                                                           | `get`                   |
| `/inventory-preload/history/notes`                                                                                     | `post`                  |
| `/inventory-preload/validate-csv`                                                                                      | `post`                  |
| `/inventory-preload/{id`}                                                                                              | `get,put,delete`        |
| `/ldap/groups`                                                                                                         | `get`                   |
| `/ldap/servers`                                                                                                        | `get`                   |
| `/notifications/alerts`                                                                                                | `get`                   |
| `/notifications/alerts/{id`}                                                                                           | `delete`                |
| `/notifications/alerts/{type}/{id`}                                                                                    | `delete`                |
| `/preview/computers`                                                                                                   | `get`                   |
| `/preview/mdm/commands`                                                                                                | `post`                  |
| `/preview/remote-administration-configurations`                                                                        | `get`                   |
| `/preview/remote-administration-configurations/team-viewer`                                                            | `post`                  |
| `/preview/remote-administration-configurations/team-viewer/{configurationId}/sessions`                                 | `get,post`              |
| `/preview/remote-administration-configurations/team-viewer/{configurationId}/sessions/{sessionId`}                     | `get`                   |
| `/preview/remote-administration-configurations/team-viewer/{configurationId}/sessions/{sessionId}/close`               | `post`                  |
| `/preview/remote-administration-configurations/team-viewer/{configurationId}/sessions/{sessionId}/resend-notification` | `post`                  |
| `/preview/remote-administration-configurations/team-viewer/{configurationId}/sessions/{sessionId}/status`              | `get`                   |
| `/preview/remote-administration-configurations/team-viewer/{id`}                                                       | `get,delete,patch`      |
| `/preview/remote-administration-configurations/team-viewer/{id}/status`                                                | `get`                   |
| `/self-service/branding/images`                                                                                        | `post`                  |
| `/settings/issueTomcatSslCertificate`                                                                                  | `post`                  |
| `/settings/obj/policyProperties`                                                                                       | `get,put`               |
| `/settings/sites`                                                                                                      | `get`                   |
| `/startup-status`                                                                                                      | `get`                   |
| `/user`                                                                                                                | `get`                   |
| `/user/obj/preference/{key`}                                                                                           | `get,put,delete`        |
| `/user/updateSession`                                                                                                  | `post`                  |
| `/v1/accounts`                                                                                                         | `post`                  |
| `/v1/accounts/{id`}                                                                                                    | `get`                   |
| `/v1/activation-code`                                                                                                  | `put`                   |
| `/v1/adue-session-token-settings`                                                                                      | `get,put`               |
| `/v1/advanced-mobile-device-searches`                                                                                  | `get,post`              |
| `/v1/advanced-mobile-device-searches/choices`                                                                          | `get`                   |
| `/v1/advanced-mobile-device-searches/delete-multiple`                                                                  | `post`                  |
| `/v1/advanced-mobile-device-searches/{id`}                                                                             | `get,put,delete`        |
| `/v1/advanced-user-content-searches`                                                                                   | `get,post`              |
| `/v1/advanced-user-content-searches/{id`}                                                                              | `get,put,delete`        |
| `/v1/api-integrations`                                                                                                 | `get,post`              |
| `/v1/api-integrations/{id`}                                                                                            | `get,put,delete`        |
| `/v1/api-integrations/{id}/client-credentials`                                                                         | `post`                  |
| `/v1/api-role-privileges`                                                                                              | `get`                   |
| `/v1/api-role-privileges/search`                                                                                       | `get`                   |
| `/v1/api-roles`                                                                                                        | `get,post`              |
| `/v1/api-roles/{id`}                                                                                                   | `get,put,delete`        |
| `/v1/app-request/form-input-fields`                                                                                    | `get,put,post`          |
| `/v1/app-request/form-input-fields/{id`}                                                                               | `get,put,delete`        |
| `/v1/app-request/settings`                                                                                             | `get,put`               |
| `/v1/app-store-country-codes`                                                                                          | `get`                   |
| `/v1/auth`                                                                                                             | `get`                   |
| `/v1/auth/invalidate-token`                                                                                            | `post`                  |
| `/v1/auth/keep-alive`                                                                                                  | `post`                  |
| `/v1/auth/token`                                                                                                       | `post`                  |
| `/v1/branding-images/download/{id`}                                                                                    | `get`                   |
| `/v1/buildings`                                                                                                        | `get,post`              |
| `/v1/buildings/delete-multiple`                                                                                        | `post`                  |
| `/v1/buildings/export`                                                                                                 | `post`                  |
| `/v1/buildings/{id`}                                                                                                   | `get,put,delete`        |
| `/v1/buildings/{id}/history`                                                                                           | `get,post`              |
| `/v1/buildings/{id}/history/export`                                                                                    | `post`                  |
| `/v1/cache-settings`                                                                                                   | `get,put`               |
| `/v1/categories`                                                                                                       | `get,post`              |
| `/v1/categories/delete-multiple`                                                                                       | `post`                  |
| `/v1/categories/{id`}                                                                                                  | `get,put,delete`        |
| `/v1/categories/{id}/history`                                                                                          | `get,post`              |
| `/v1/classic-ldap/{id`}                                                                                                | `get`                   |
| `/v1/cloud-azure`                                                                                                      | `post`                  |
| `/v1/cloud-azure/defaults/mappings`                                                                                    | `get`                   |
| `/v1/cloud-azure/defaults/server-configuration`                                                                        | `get`                   |
| `/v1/cloud-azure/{id`}                                                                                                 | `get,put,delete`        |
| `/v1/cloud-distribution-point`                                                                                         | `get,post,delete,patch` |
| `/v1/cloud-distribution-point/history`                                                                                 | `get,post`              |
| `/v1/cloud-distribution-point/inventory-files`                                                                         | `get`                   |
| `/v1/cloud-distribution-point/test-connection`                                                                         | `get`                   |
| `/v1/cloud-distribution-point/upload-capability`                                                                       | `get`                   |
| `/v1/cloud-idp`                                                                                                        | `get`                   |
| `/v1/cloud-idp/export`                                                                                                 | `post`                  |
| `/v1/cloud-idp/{id`}                                                                                                   | `get`                   |
| `/v1/cloud-idp/{id}/history`                                                                                           | `get,post`              |
| `/v1/cloud-idp/{id}/test-group`                                                                                        | `post`                  |
| `/v1/cloud-idp/{id}/test-user`                                                                                         | `post`                  |
| `/v1/cloud-idp/{id}/test-user-membership`                                                                              | `post`                  |
| `/v1/cloud-information`                                                                                                | `get`                   |
| `/v1/computer-extension-attributes`                                                                                    | `get,post`              |
| `/v1/computer-extension-attributes/delete-multiple`                                                                    | `post`                  |
| `/v1/computer-extension-attributes/templates`                                                                          | `get`                   |
| `/v1/computer-extension-attributes/templates/{id`}                                                                     | `get`                   |
| `/v1/computer-extension-attributes/upload`                                                                             | `post`                  |
| `/v1/computer-extension-attributes/{id`}                                                                               | `get,put,delete`        |
| `/v1/computer-extension-attributes/{id}/data-dependency`                                                               | `get`                   |
| `/v1/computer-extension-attributes/{id}/history`                                                                       | `get,post`              |
| `/v1/computer-groups`                                                                                                  | `get`                   |
| `/v1/computer-inventory-collection-settings`                                                                           | `get,patch`             |
| `/v1/computer-inventory-collection-settings/custom-path`                                                               | `post`                  |
| `/v1/computer-inventory-collection-settings/custom-path/{id`}                                                          | `delete`                |
| `/v1/computer-inventory/{id}/erase`                                                                                    | `post`                  |
| `/v1/computer-inventory/{id}/remove-mdm-profile`                                                                       | `post`                  |
| `/v1/computer-prestages/scope`                                                                                         | `get`                   |
| `/v1/computer-prestages/{id}/scope`                                                                                    | `get,put,post,delete`   |
| `/v1/computers-inventory`                                                                                              | `get`                   |
| `/v1/computers-inventory-detail/{id`}                                                                                  | `get,patch`             |
| `/v1/computers-inventory/filevault`                                                                                    | `get`                   |
| `/v1/computers-inventory/{id`}                                                                                         | `get,delete`            |
| `/v1/computers-inventory/{id}/attachments`                                                                             | `post`                  |
| `/v1/computers-inventory/{id}/attachments/{attachmentId`}                                                              | `get,delete`            |
| `/v1/computers-inventory/{id}/filevault`                                                                               | `get`                   |
| `/v1/computers-inventory/{id}/view-recovery-lock-password`                                                             | `get`                   |
| `/v1/computers/{id}/recalculate-smart-groups`                                                                          | `post`                  |
| `/v1/conditional-access/device-compliance-information/computer/{deviceId`}                                             | `get`                   |
| `/v1/conditional-access/device-compliance-information/mobile/{deviceId`}                                               | `get`                   |
| `/v1/conditional-access/device-compliance/feature-toggle`                                                              | `get`                   |
| `/v1/csa/tenant-id`                                                                                                    | `get`                   |
| `/v1/csa/token`                                                                                                        | `get,delete`            |
| `/v1/dashboard`                                                                                                        | `get`                   |
| `/v1/ddm/{clientManagementId}/status-items`                                                                            | `get`                   |
| `/v1/ddm/{clientManagementId}/status-items/{key`}                                                                      | `get`                   |
| `/v1/ddm/{clientManagementId}/sync`                                                                                    | `post`                  |
| `/v1/departments`                                                                                                      | `get,post`              |
| `/v1/departments/delete-multiple`                                                                                      | `post`                  |
| `/v1/departments/{id`}                                                                                                 | `get,put,delete`        |
| `/v1/departments/{id}/history`                                                                                         | `get,post`              |
| `/v1/deploy-package`                                                                                                   | `post`                  |
| `/v1/device-communication-settings`                                                                                    | `get,put`               |
| `/v1/device-communication-settings/history`                                                                            | `get,post`              |
| `/v1/device-enrollments`                                                                                               | `get`                   |
| `/v1/device-enrollments/public-key`                                                                                    | `get`                   |
| `/v1/device-enrollments/syncs`                                                                                         | `get`                   |
| `/v1/device-enrollments/upload-token`                                                                                  | `post`                  |
| `/v1/device-enrollments/{id`}                                                                                          | `get,put,delete`        |
| `/v1/device-enrollments/{id}/devices`                                                                                  | `get`                   |
| `/v1/device-enrollments/{id}/disown`                                                                                   | `post`                  |
| `/v1/device-enrollments/{id}/history`                                                                                  | `get,post`              |
| `/v1/device-enrollments/{id}/syncs`                                                                                    | `get`                   |
| `/v1/device-enrollments/{id}/syncs/latest`                                                                             | `get`                   |
| `/v1/device-enrollments/{id}/upload-token`                                                                             | `put`                   |
| `/v1/dock-items`                                                                                                       | `post`                  |
| `/v1/dock-items/{id`}                                                                                                  | `get,put,delete`        |
| `/v1/dss-declarations/{id`}                                                                                            | `get`                   |
| `/v1/ebooks`                                                                                                           | `get`                   |
| `/v1/ebooks/{id`}                                                                                                      | `get`                   |
| `/v1/ebooks/{id}/scope`                                                                                                | `get`                   |
| `/v1/engage`                                                                                                           | `get,put`               |
| `/v1/engage/history`                                                                                                   | `get,post`              |
| `/v1/enrollment-customization`                                                                                         | `get,post`              |
| `/v1/enrollment-customization/images`                                                                                  | `post`                  |
| `/v1/enrollment-customization/parse-markdown`                                                                          | `post`                  |
| `/v1/enrollment-customization/{id`}                                                                                    | `get,put,delete`        |
| `/v1/enrollment-customization/{id}/all`                                                                                | `get`                   |
| `/v1/enrollment-customization/{id}/all/{panel-id`}                                                                     | `get,delete`            |
| `/v1/enrollment-customization/{id}/history`                                                                            | `get,post`              |
| `/v1/enrollment-customization/{id}/ldap`                                                                               | `post`                  |
| `/v1/enrollment-customization/{id}/ldap/{panel-id`}                                                                    | `get,put,delete`        |
| `/v1/enrollment-customization/{id}/prestages`                                                                          | `get`                   |
| `/v1/enrollment-customization/{id}/sso`                                                                                | `post`                  |
| `/v1/enrollment-customization/{id}/sso/{panel-id`}                                                                     | `get,put,delete`        |
| `/v1/enrollment-customization/{id}/text`                                                                               | `post`                  |
| `/v1/enrollment-customization/{id}/text/{panel-id`}                                                                    | `get,put,delete`        |
| `/v1/enrollment-customization/{id}/text/{panel-id}/markdown`                                                           | `get`                   |
| `/v1/groups`                                                                                                           | `get`                   |
| `/v1/groups/{id`}                                                                                                      | `get`                   |
| `/v1/gsx-connection`                                                                                                   | `get,put,patch`         |
| `/v1/gsx-connection/history`                                                                                           | `get,post`              |
| `/v1/gsx-connection/test`                                                                                              | `post`                  |
| `/v1/health-check`                                                                                                     | `get`                   |
| `/v1/icon`                                                                                                             | `post`                  |
| `/v1/icon/download/{id`}                                                                                               | `get`                   |
| `/v1/icon/{id`}                                                                                                        | `get`                   |
| `/v1/inventory-information`                                                                                            | `get`                   |
| `/v1/inventory-preload`                                                                                                | `get,post,delete`       |
| `/v1/inventory-preload/csv-template`                                                                                   | `get`                   |
| `/v1/inventory-preload/history`                                                                                        | `get,post`              |
| `/v1/inventory-preload/validate-csv`                                                                                   | `post`                  |
| `/v1/inventory-preload/{id`}                                                                                           | `get,put,delete`        |
| `/v1/jamf-connect`                                                                                                     | `get`                   |
| `/v1/jamf-connect/config-profiles`                                                                                     | `get`                   |
| `/v1/jamf-connect/config-profiles/{id`}                                                                                | `put`                   |
| `/v1/jamf-connect/deployments/{id}/tasks`                                                                              | `get`                   |
| `/v1/jamf-connect/deployments/{id}/tasks/retry`                                                                        | `post`                  |
| `/v1/jamf-connect/history`                                                                                             | `get,post`              |
| `/v1/jamf-management-framework/redeploy/{id`}                                                                          | `post`                  |
| `/v1/jamf-package`                                                                                                     | `get`                   |
| `/v1/jamf-pro-information`                                                                                             | `get`                   |
| `/v1/jamf-pro-server-url`                                                                                              | `get,put`               |
| `/v1/jamf-pro-server-url/history`                                                                                      | `get,post`              |
| `/v1/jamf-pro-version`                                                                                                 | `get`                   |
| `/v1/jamf-protect`                                                                                                     | `get,put,delete`        |
| `/v1/jamf-protect/deployments/{id}/tasks`                                                                              | `get`                   |
| `/v1/jamf-protect/deployments/{id}/tasks/retry`                                                                        | `post`                  |
| `/v1/jamf-protect/history`                                                                                             | `get,post`              |
| `/v1/jamf-protect/plans`                                                                                               | `get`                   |
| `/v1/jamf-protect/plans/sync`                                                                                          | `post`                  |
| `/v1/jamf-protect/register`                                                                                            | `post`                  |
| `/v1/jamf-remote-assist/session`                                                                                       | `get`                   |
| `/v1/jamf-remote-assist/session/{id`}                                                                                  | `get`                   |
| `/v1/jcds/files`                                                                                                       | `get,post`              |
| `/v1/jcds/files/{fileName`}                                                                                            | `get,delete`            |
| `/v1/jcds/properties`                                                                                                  | `get`                   |
| `/v1/jcds/refresh-inventory`                                                                                           | `post`                  |
| `/v1/jcds/renew-credentials`                                                                                           | `post`                  |
| `/v1/ldap-keystore/verify`                                                                                             | `post`                  |
| `/v1/ldap/groups`                                                                                                      | `get`                   |
| `/v1/ldap/ldap-servers`                                                                                                | `get`                   |
| `/v1/ldap/servers`                                                                                                     | `get`                   |
| `/v1/locales`                                                                                                          | `get`                   |
| `/v1/log-flushing`                                                                                                     | `get`                   |
| `/v1/log-flushing/task`                                                                                                | `get,post`              |
| `/v1/log-flushing/task/{id`}                                                                                           | `get,delete,parameters` |
| `/v1/login-customization`                                                                                              | `get,put`               |
| `/v1/macos-managed-software-updates/available-updates`                                                                 | `get`                   |
| `/v1/macos-managed-software-updates/send-updates`                                                                      | `post`                  |
| `/v1/managed-software-updates/available-updates`                                                                       | `get`                   |
| `/v1/managed-software-updates/plans`                                                                                   | `get,post`              |
| `/v1/managed-software-updates/plans/feature-toggle`                                                                    | `get,put`               |
| `/v1/managed-software-updates/plans/feature-toggle/abandon`                                                            | `post`                  |
| `/v1/managed-software-updates/plans/feature-toggle/status`                                                             | `get`                   |
| `/v1/managed-software-updates/plans/group`                                                                             | `post`                  |
| `/v1/managed-software-updates/plans/group/{id`}                                                                        | `get`                   |
| `/v1/managed-software-updates/plans/{id`}                                                                              | `get`                   |
| `/v1/managed-software-updates/plans/{id}/declarations`                                                                 | `get`                   |
| `/v1/managed-software-updates/plans/{id}/events`                                                                       | `get`                   |
| `/v1/managed-software-updates/update-statuses`                                                                         | `get`                   |
| `/v1/managed-software-updates/update-statuses/computer-groups/{id`}                                                    | `get`                   |
| `/v1/managed-software-updates/update-statuses/computers/{id`}                                                          | `get`                   |
| `/v1/managed-software-updates/update-statuses/mobile-device-groups/{id`}                                               | `get`                   |
| `/v1/managed-software-updates/update-statuses/mobile-devices/{id`}                                                     | `get`                   |
| `/v1/mdm/commands`                                                                                                     | `get`                   |
| `/v1/mdm/renew-profile`                                                                                                | `post`                  |
| `/v1/mobile-device-apps/reinstall-app-config`                                                                          | `post`                  |
| `/v1/mobile-device-enrollment-profile/{id}/download-profile`                                                           | `get`                   |
| `/v1/mobile-device-groups`                                                                                             | `get`                   |
| `/v1/mobile-device-groups/static-group-membership/{id`}                                                                | `get`                   |
| `/v1/mobile-device-groups/static-groups`                                                                               | `get,post`              |
| `/v1/mobile-device-groups/static-groups/{id`}                                                                          | `get,delete,patch`      |
| `/v1/mobile-device-prestages`                                                                                          | `get,post`              |
| `/v1/mobile-device-prestages/scope`                                                                                    | `get`                   |
| `/v1/mobile-device-prestages/sync`                                                                                     | `get`                   |
| `/v1/mobile-device-prestages/sync/{id`}                                                                                | `get`                   |
| `/v1/mobile-device-prestages/sync/{id}/latest`                                                                         | `get`                   |
| `/v1/mobile-device-prestages/{id`}                                                                                     | `get,put,delete`        |
| `/v1/mobile-device-prestages/{id}/attachments`                                                                         | `get,post,delete`       |
| `/v1/mobile-device-prestages/{id}/history`                                                                             | `get,post`              |
| `/v1/mobile-device-prestages/{id}/scope`                                                                               | `get,put,post,delete`   |
| `/v1/mobile-devices/{id}/recalculate-smart-groups`                                                                     | `post`                  |
| `/v1/notifications`                                                                                                    | `get`                   |
| `/v1/notifications/{type}/{id`}                                                                                        | `delete`                |
| `/v1/oauth/token`                                                                                                      | `post`                  |
| `/v1/oauth2/session-tokens`                                                                                            | `get`                   |
| `/v1/oidc/dispatch`                                                                                                    | `post`                  |
| `/v1/oidc/generate-certificate`                                                                                        | `post`                  |
| `/v1/oidc/public-key`                                                                                                  | `get`                   |
| `/v1/onboarding`                                                                                                       | `get,put`               |
| `/v1/onboarding/eligible-apps`                                                                                         | `get`                   |
| `/v1/onboarding/eligible-configuration-profiles`                                                                       | `get`                   |
| `/v1/onboarding/eligible-policies`                                                                                     | `get`                   |
| `/v1/onboarding/history`                                                                                               | `get,post`              |
| `/v1/onboarding/history/export`                                                                                        | `post`                  |
| `/v1/packages`                                                                                                         | `get,post`              |
| `/v1/packages/delete-multiple`                                                                                         | `post`                  |
| `/v1/packages/export`                                                                                                  | `post`                  |
| `/v1/packages/{id`}                                                                                                    | `get,put,delete`        |
| `/v1/packages/{id}/history`                                                                                            | `get,post`              |
| `/v1/packages/{id}/history/export`                                                                                     | `post`                  |
| `/v1/packages/{id}/manifest`                                                                                           | `post,delete`           |
| `/v1/packages/{id}/upload`                                                                                             | `post`                  |
| `/v1/parent-app`                                                                                                       | `get,put`               |
| `/v1/parent-app/history`                                                                                               | `get,post`              |
| `/v1/pki/adcs-settings`                                                                                                | `post`                  |
| `/v1/pki/adcs-settings/validate-certificate`                                                                           | `post`                  |
| `/v1/pki/adcs-settings/validate-client-certificate`                                                                    | `post`                  |
| `/v1/pki/adcs-settings/{id`}                                                                                           | `get,delete,patch`      |
| `/v1/pki/adcs-settings/{id}/dependencies`                                                                              | `get`                   |
| `/v1/pki/adcs-settings/{id}/history`                                                                                   | `get,post`              |
| `/v1/pki/certificate-authority/active`                                                                                 | `get`                   |
| `/v1/pki/certificate-authority/active/der`                                                                             | `get`                   |
| `/v1/pki/certificate-authority/active/pem`                                                                             | `get`                   |
| `/v1/pki/certificate-authority/{id`}                                                                                   | `get`                   |
| `/v1/pki/certificate-authority/{id}/der`                                                                               | `get`                   |
| `/v1/pki/certificate-authority/{id}/pem`                                                                               | `get`                   |
| `/v1/pki/venafi`                                                                                                       | `post`                  |
| `/v1/pki/venafi/{id`}                                                                                                  | `get,delete,patch`      |
| `/v1/pki/venafi/{id}/connection-status`                                                                                | `get`                   |
| `/v1/pki/venafi/{id}/dependent-profiles`                                                                               | `get`                   |
| `/v1/pki/venafi/{id}/history`                                                                                          | `get,post`              |
| `/v1/pki/venafi/{id}/jamf-public-key`                                                                                  | `get`                   |
| `/v1/pki/venafi/{id}/jamf-public-key/regenerate`                                                                       | `post`                  |
| `/v1/pki/venafi/{id}/proxy-trust-store`                                                                                | `get,post,delete`       |
| `/v1/policy-properties`                                                                                                | `get,put`               |
| `/v1/reenrollment`                                                                                                     | `get,put`               |
| `/v1/reenrollment/history`                                                                                             | `get,post`              |
| `/v1/reenrollment/history/export`                                                                                      | `post`                  |
| `/v1/return-to-service`                                                                                                | `get,post`              |
| `/v1/return-to-service/{id`}                                                                                           | `get,put,delete`        |
| `/v1/scheduler/jobs`                                                                                                   | `get`                   |
| `/v1/scheduler/jobs/{jobKey}/triggers`                                                                                 | `get`                   |
| `/v1/scheduler/summary`                                                                                                | `get`                   |
| `/v1/scripts`                                                                                                          | `get,post`              |
| `/v1/scripts/{id`}                                                                                                     | `get,put,delete`        |
| `/v1/scripts/{id}/download`                                                                                            | `get`                   |
| `/v1/scripts/{id}/history`                                                                                             | `get,post`              |
| `/v1/self-service/branding/ios`                                                                                        | `get,post`              |
| `/v1/self-service/branding/ios/{id`}                                                                                   | `get,put,delete`        |
| `/v1/self-service/branding/macos`                                                                                      | `get,post`              |
| `/v1/self-service/branding/macos/{id`}                                                                                 | `get,put,delete`        |
| `/v1/self-service/settings`                                                                                            | `get,put`               |
| `/v1/sites`                                                                                                            | `get`                   |
| `/v1/sites/{id}/objects`                                                                                               | `get`                   |
| `/v1/slasa`                                                                                                            | `get,post`              |
| `/v1/smart-computer-groups/{id}/recalculate`                                                                           | `post`                  |
| `/v1/smart-mobile-device-groups/{id}/recalculate`                                                                      | `post`                  |
| `/v1/smart-user-groups/{id}/recalculate`                                                                               | `post`                  |
| `/v1/smtp-server`                                                                                                      | `get,put`               |
| `/v1/smtp-server/history`                                                                                              | `get,post`              |
| `/v1/smtp-server/test`                                                                                                 | `post`                  |
| `/v1/sso/failover`                                                                                                     | `get`                   |
| `/v1/sso/failover/generate`                                                                                            | `post`                  |
| `/v1/static-user-groups`                                                                                               | `get`                   |
| `/v1/static-user-groups/{id`}                                                                                          | `get`                   |
| `/v1/supervision-identities`                                                                                           | `get,post`              |
| `/v1/supervision-identities/upload`                                                                                    | `post`                  |
| `/v1/supervision-identities/{id`}                                                                                      | `get,put,delete`        |
| `/v1/supervision-identities/{id}/download`                                                                             | `get`                   |
| `/v1/system/initialize`                                                                                                | `post`                  |
| `/v1/system/initialize-database-connection`                                                                            | `post`                  |
| `/v1/teacher-app`                                                                                                      | `get,put`               |
| `/v1/teacher-app/history`                                                                                              | `get,post`              |
| `/v1/time-zones`                                                                                                       | `get`                   |
| `/v1/user/change-password`                                                                                             | `post`                  |
| `/v1/user/preferences/settings/{keyId`}                                                                                | `get`                   |
| `/v1/user/preferences/{keyId`}                                                                                         | `get,put,delete`        |
| `/v1/users/{id}/recalculate-smart-groups`                                                                              | `post`                  |
| `/v1/volume-purchasing-locations`                                                                                      | `get,post`              |
| `/v1/volume-purchasing-locations/{id`}                                                                                 | `get,delete,patch`      |
| `/v1/volume-purchasing-locations/{id}/content`                                                                         | `get`                   |
| `/v1/volume-purchasing-locations/{id}/history`                                                                         | `get,post`              |
| `/v1/volume-purchasing-locations/{id}/reclaim`                                                                         | `post`                  |
| `/v1/volume-purchasing-locations/{id}/revoke-licenses`                                                                 | `post`                  |
| `/v1/volume-purchasing-subscriptions`                                                                                  | `get,post`              |
| `/v1/volume-purchasing-subscriptions/{id`}                                                                             | `get,put,delete`        |
| `/v1/volume-purchasing-subscriptions/{id}/history`                                                                     | `get,post`              |
| `/v2/account-preferences`                                                                                              | `get,patch`             |
| `/v2/cloud-ldaps`                                                                                                      | `post`                  |
| `/v2/cloud-ldaps/defaults/{provider}/mappings`                                                                         | `get`                   |
| `/v2/cloud-ldaps/defaults/{provider}/server-configuration`                                                             | `get`                   |
| `/v2/cloud-ldaps/{id`}                                                                                                 | `get,put,delete`        |
| `/v2/cloud-ldaps/{id}/connection/bind`                                                                                 | `get`                   |
| `/v2/cloud-ldaps/{id}/connection/search`                                                                               | `get`                   |
| `/v2/cloud-ldaps/{id}/connection/status`                                                                               | `get`                   |
| `/v2/cloud-ldaps/{id}/mappings`                                                                                        | `get,put`               |
| `/v2/computer-groups/smart-group-membership/{id`}                                                                      | `get`                   |
| `/v2/computer-groups/smart-groups`                                                                                     | `get,post`              |
| `/v2/computer-groups/smart-groups/{id`}                                                                                | `put,delete`            |
| `/v2/computer-prestages`                                                                                               | `get,post`              |
| `/v2/computer-prestages/scope`                                                                                         | `get`                   |
| `/v2/computer-prestages/{id`}                                                                                          | `get,put,delete`        |
| `/v2/computer-prestages/{id}/scope`                                                                                    | `get,put,post`          |
| `/v2/computer-prestages/{id}/scope/delete-multiple`                                                                    | `post`                  |
| `/v2/engage`                                                                                                           | `get,put`               |
| `/v2/engage/history`                                                                                                   | `get,post`              |
| `/v2/enrollment`                                                                                                       | `get,put`               |
| `/v2/enrollment-customizations`                                                                                        | `get,post`              |
| `/v2/enrollment-customizations/images`                                                                                 | `post`                  |
| `/v2/enrollment-customizations/images/{id`}                                                                            | `get`                   |
| `/v2/enrollment-customizations/{id`}                                                                                   | `get,put,delete`        |
| `/v2/enrollment-customizations/{id}/history`                                                                           | `get,post`              |
| `/v2/enrollment-customizations/{id}/prestages`                                                                         | `get`                   |
| `/v2/enrollment/access-groups`                                                                                         | `get,post`              |
| `/v2/enrollment/access-groups/{serverId}/{groupId`}                                                                    | `get,put,delete`        |
| `/v2/enrollment/filtered-language-codes`                                                                               | `get`                   |
| `/v2/enrollment/history`                                                                                               | `get,post`              |
| `/v2/enrollment/history/export`                                                                                        | `post`                  |
| `/v2/enrollment/language-codes`                                                                                        | `get`                   |
| `/v2/enrollment/languages`                                                                                             | `get`                   |
| `/v2/enrollment/languages/delete-multiple`                                                                             | `post`                  |
| `/v2/enrollment/languages/{languageId`}                                                                                | `get,put,delete`        |
| `/v2/inventory-preload/csv`                                                                                            | `get,post`              |
| `/v2/inventory-preload/csv-template`                                                                                   | `get`                   |
| `/v2/inventory-preload/csv-validate`                                                                                   | `post`                  |
| `/v2/inventory-preload/ea-columns`                                                                                     | `get`                   |
| `/v2/inventory-preload/export`                                                                                         | `post`                  |
| `/v2/inventory-preload/history`                                                                                        | `get,post`              |
| `/v2/inventory-preload/records`                                                                                        | `get,post`              |
| `/v2/inventory-preload/records/delete-all`                                                                             | `post`                  |
| `/v2/inventory-preload/records/{id`}                                                                                   | `get,put,delete`        |
| `/v2/jamf-package`                                                                                                     | `get`                   |
| `/v2/jamf-pro-information`                                                                                             | `get`                   |
| `/v2/jamf-remote-assist/session`                                                                                       | `get`                   |
| `/v2/jamf-remote-assist/session/export`                                                                                | `post`                  |
| `/v2/jamf-remote-assist/session/{id`}                                                                                  | `get`                   |
| `/v2/local-admin-password/pending-rotations`                                                                           | `get`                   |
| `/v2/local-admin-password/settings`                                                                                    | `get,put`               |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/audit`                                               | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/history`                                             | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/password`                                            | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/{guid}/audit`                                        | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/{guid}/history`                                      | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/account/{username}/{guid}/password`                                     | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/accounts`                                                               | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/history`                                                                | `get`                   |
| `/v2/local-admin-password/{clientManagementId}/set-password`                                                           | `put`                   |
| `/v2/mdm/commands`                                                                                                     | `get,post`              |
| `/v2/mobile-device-prestages`                                                                                          | `get,post`              |
| `/v2/mobile-device-prestages/scope`                                                                                    | `get`                   |
| `/v2/mobile-device-prestages/syncs`                                                                                    | `get`                   |
| `/v2/mobile-device-prestages/{id`}                                                                                     | `get,put,delete`        |
| `/v2/mobile-device-prestages/{id}/attachments`                                                                         | `get,post`              |
| `/v2/mobile-device-prestages/{id}/attachments/delete-multiple`                                                         | `post`                  |
| `/v2/mobile-device-prestages/{id}/history`                                                                             | `get,post`              |
| `/v2/mobile-device-prestages/{id}/scope`                                                                               | `get,put,post`          |
| `/v2/mobile-device-prestages/{id}/scope/delete-multiple`                                                               | `post`                  |
| `/v2/mobile-device-prestages/{id}/syncs`                                                                               | `get`                   |
| `/v2/mobile-device-prestages/{id}/syncs/latest`                                                                        | `get`                   |
| `/v2/mobile-devices`                                                                                                   | `get`                   |
| `/v2/mobile-devices/detail`                                                                                            | `get`                   |
| `/v2/mobile-devices/{id`}                                                                                              | `get,patch`             |
| `/v2/mobile-devices/{id}/detail`                                                                                       | `get`                   |
| `/v2/mobile-devices/{id}/erase`                                                                                        | `post`                  |
| `/v2/mobile-devices/{id}/paired-devices`                                                                               | `get`                   |
| `/v2/mobile-devices/{id}/unmanage`                                                                                     | `post`                  |
| `/v2/patch-management-accept-disclaimer`                                                                               | `post`                  |
| `/v2/patch-policies`                                                                                                   | `get`                   |
| `/v2/patch-policies/policy-details`                                                                                    | `get`                   |
| `/v2/patch-policies/{id}/dashboard`                                                                                    | `get,post,delete`       |
| `/v2/patch-policies/{id}/logs`                                                                                         | `get`                   |
| `/v2/patch-policies/{id}/logs/eligible-retry-count`                                                                    | `get`                   |
| `/v2/patch-policies/{id}/logs/retry`                                                                                   | `post`                  |
| `/v2/patch-policies/{id}/logs/retry-all`                                                                               | `post`                  |
| `/v2/patch-policies/{id}/logs/{deviceId`}                                                                              | `get`                   |
| `/v2/patch-policies/{id}/logs/{deviceId}/details`                                                                      | `get`                   |
| `/v2/patch-software-title-configurations`                                                                              | `get,post`              |
| `/v2/patch-software-title-configurations/{id`}                                                                         | `get,delete,patch`      |
| `/v2/patch-software-title-configurations/{id}/dashboard`                                                               | `get,post,delete`       |
| `/v2/patch-software-title-configurations/{id}/definitions`                                                             | `get`                   |
| `/v2/patch-software-title-configurations/{id}/dependencies`                                                            | `get`                   |
| `/v2/patch-software-title-configurations/{id}/export-report`                                                           | `get`                   |
| `/v2/patch-software-title-configurations/{id}/extension-attributes`                                                    | `get`                   |
| `/v2/patch-software-title-configurations/{id}/history`                                                                 | `get,post`              |
| `/v2/patch-software-title-configurations/{id}/patch-report`                                                            | `get`                   |
| `/v2/patch-software-title-configurations/{id}/patch-summary`                                                           | `get`                   |
| `/v2/patch-software-title-configurations/{id}/patch-summary/versions`                                                  | `get`                   |
| `/v2/smtp-server`                                                                                                      | `get,put`               |
| `/v2/sso`                                                                                                              | `get,put`               |
| `/v2/sso/cert`                                                                                                         | `get,put,post,delete`   |
| `/v2/sso/cert/download`                                                                                                | `get`                   |
| `/v2/sso/cert/parse`                                                                                                   | `post`                  |
| `/v2/sso/dependencies`                                                                                                 | `get`                   |
| `/v2/sso/disable`                                                                                                      | `post`                  |
| `/v2/sso/history`                                                                                                      | `get,post`              |
| `/v2/sso/metadata/download`                                                                                            | `get`                   |
| `/v2/sso/validate`                                                                                                     | `post`                  |
| `/v3/check-in`                                                                                                         | `get,put`               |
| `/v3/check-in/history`                                                                                                 | `get,post`              |
| `/v3/computer-prestages`                                                                                               | `get,post`              |
| `/v3/computer-prestages/{id`}                                                                                          | `get,put,delete`        |
| `/v3/enrollment`                                                                                                       | `get,put`               |
| `/v3/enrollment/access-groups`                                                                                         | `get,post`              |
| `/v3/enrollment/access-groups/{id`}                                                                                    | `get,put,delete`        |
| `/v3/enrollment/filtered-language-codes`                                                                               | `get`                   |
| `/v3/enrollment/language-codes`                                                                                        | `get`                   |
| `/v3/enrollment/languages`                                                                                             | `get`                   |
| `/v3/enrollment/languages/delete-multiple`                                                                             | `post`                  |
| `/v3/enrollment/languages/{languageId`}                                                                                | `get,put,delete`        |
| `/v3/sso`                                                                                                              | `get,put`               |
| `/v3/sso/dependencies`                                                                                                 | `get`                   |
| `/v3/sso/disable`                                                                                                      | `post`                  |
| `/v3/sso/history`                                                                                                      | `get,post`              |
| `/v3/sso/metadata/download`                                                                                            | `get`                   |
| `/v4/enrollment`                                                                                                       | `get,put`               |

- - - 

# SCRATCH

```javascript
paths 
| select( last=="deprecated" ) 
| map( . |= .[0:rindex("deprecated")] )  # // only keep array entries until but not including "deprecated"
| reduce .[] as $section ( {}; .[$section[0]] += [$section[1:]] ) 
| to_entries 
| map( 
    .key as $key 
    | .value 
    | reduce .[] as $item ( {}; .[$item[0]] += $item[1:] ) 
    | { key: $key, value: . } 
  ) 
| from_entries'
```
