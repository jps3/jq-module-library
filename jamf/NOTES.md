# jq - Jamf API
# yq - Jamf Classic

## TODO

- [x] Should probably create a generic 'swagger' or 'openapi' folder on same level as 'jamf' not within.

## Ideas

- cli using '«cmd» «noun» [«opts»] «verb» [«opts] [«target(s)»] …'
	- `jamf api … `
	- `jamf classic … `
	- `jamf schema [--jpapi (default) | --classic] …`
- invisibly simple and/or automagic check of `.totalCount == (.results|length)` to ensure all intended records are retrieved.


## Connecting/Relating Object Types

- (device enrollment instance)
- `/v2/computer-prestages/scope` 
- `/v1/computers-inventory?filter=hardware.serialNumber=in=(sn1,sn2,...)`

- /v1/device-enrollments
	- id, name, serverName, serverUuid, adminId, orgName, orgEmail, orgPhone, orgAddress, tokenExpiration
	- /syncs --> _array_ (of _object_) _(appears to only include 10-qty for each enrollment instance id)_
	- /{id}
		- /syncs --> _array_ (of _object_) _(appears to only include last 10 entries)_
			- /latest --> _object_
		- /devices --> _array_ (of _object_)
			- id _(appears distinct to device enrollment not device.deviceId)_, deviceEnrollmentProgramInstanceId, prestageId, serialNumber, description, model, color, profileStatus, syncState _object_, profileAssignTime, profilePushTime, deviceAssignedDate
				- syncState: id _(does not appear to be device.DeviceId)_, serialNumber, profileUUID, syncStatus, failureCount, timestamp

- /v1/managed-software-updates/plans to /v1/managed-software-updates/update-statuses
  - plans
    - /v1/managed-software-updates/plans
      - `GET` parameter `filter`: "Query in the RSQL format, allowing to filter Managed Software Updates collection. Default filter is empty query - returning all results for the requested page. Fields allowed in the query: planUuid, device.deviceId, device.objectType, updateAction, versionType, specificVersion, maxDeferrals, recipeId, forceInstallLocalDateTime, state."  
    - /v1/managed-software-updates/plans/group
    - /v1/managed-software-updates/plans/group/{id}
    - /v1/managed-software-updates/plans/{id}
    - /v1/managed-software-updates/plans/{id}/declarations
    - /v1/managed-software-updates/plans/{id}/events --> “\*--events--events--\*”
  - update-statuses
    - /v1/managed-software-updates/update-statuses
    - /v1/managed-software-updates/update-statuses/computer-groups/{id}
    - /v1/managed-software-updates/update-statuses/computers/{id}

- - - 

### Managed Software Updates

#### Plans

#### Update Statuses

- - - 

### Computer Prestages

#### /v3/computer-prestages

```json
{
  "totalCount": 11,
  "results": [
    {
      "keepExistingSiteMembership": false,
      "enrollmentSiteId": "-1",
      "id": "4",
      "displayName": "DEP Enrollment - LABS",
      // ...snip...
      "mandatory": true,
      "mdmRemovable": false,
      "defaultPrestage": true,
      "keepExistingLocationInformation": true,
      // ...snip...
      "profileUuid": "FEF17A9276CC03CDE6854C41AE1385E3",   // <--- relates to device-enrollment data
      "deviceEnrollmentProgramInstanceId": "2",
      // ...snip...
      "skipSetupItems": {  },       // ...snip...
      "locationInformation": { },   // ...snip...
      "purchasingInformation": { }, // ...snip...
      // ...snip...
      "installProfilesDuringSetup": true,
      "prestageInstalledProfileIds": [],
      "enableRecoveryLock": true,
      "recoveryLockPasswordType": "RANDOM",
      "rotateRecoveryLockPassword": true,
      "prestageMinimumOsTargetVersionType": "NO_ENFORCEMENT",
      "minimumOsSpecificVersion": "",
      "accountSettings": { }        // ...snip...
    },
    // ...snip...
  ]
}
```

#### /v2/computer-prestages/{id}/scope

```json
{
  "prestageId": "18",
  "assignments": [
    {
      "serialNumber": "JJP7W2LHFC",
      "assignmentDate": "2023-07-24T10:26:24.715",
      "userAssigned": "system"
    },
    // ...snip...
  ],
  "versionLock": 1025
}
```


#### /v2/computer-prestages/scope
```json
{
  "serialsByPrestageId": {
    "F4LJ4K9CXC": "18",
    "DWR4R6NWFV": "18",
    "C02CM0GKMNHY": "18",
    "GWC7YF76XG": "18",
    "DY9RFWM677": "18",
    "C02FV1RVQ05P": "18",
    "H7404R26JM": "18",
    // ...snip...
  }
}
```

- - - 

### device enrollment object 
**schema** _(edited for clarity)_
```json
{
  "type": "object",
  "properties": {
    "id":                                { "type": "string"  },
    "deviceEnrollmentProgramInstanceId": { "type": "string"  },
    "prestageId":                        { "type": "string"  },
    "serialNumber":                      { "type": "string"  },
    "description":                       { "type": "string"  },
    "model":                             { "type": "string"  },
    "color":                             { "type": "string"  },
    "assetTag":                          { "type": "string"  },
    "profileStatus": {
      "type": "string",
      "enum": ["EMPTY", "ASSIGNED", "PUSHED", "REMOVED"]
    },
    "syncState": {
		"$ref": "#/components/schemas/AssignRemoveProfileResponseSyncState",
		"$$ref": {
			"type": "object",
			"properties": {
				"id":                    { "type": "integer" },
				"serialNumber":          { "type": "string"  },
				"profileUUID":           { "type": "string"  },
				"syncStatus":            { "type": "string"  },
				"failureCount":          { "type": "integer" },
				"timestamp":             { "type": "integer" }
			}
		}
    },
    "profileAssignTime":                 { "type": "string"  },
    "profilePushTime":                   { "type": "string"  },
    "deviceAssignedDate":                { "type": "string"  }
  }
}
```

**Example**
```json
[
  {
    "id": "444876",
    "deviceEnrollmentProgramInstanceId": "1",
    "prestageId": "18",
    "serialNumber": "C02FH35PQ05N",
    "description": "MBP 13.3 SPG/8C CPU/8C GPU",
    "model": "MacBook Pro 13\"",
    "color": "SPACE GRAY",
    "assetTag": "",
    "profileStatus": "PUSHED",
    "syncState": {
      "id": 440,                                         // does not appear to be index number from prestage .assignments array
      "serialNumber": "C02FH35PQ05N",
      "profileUUID": "2A53851A0BC11D856B2E2E85E6B1B69D", // Prestage’s profileUuuid
      "syncStatus": "ASSIGN_SUCCESS",                    // related to Prestage assignment ???
      "failureCount": 0,
      "timestamp": 1732724004493
    },
    "profileAssignTime": "2024-11-27T16:13:24Z",
    "profilePushTime": "2025-01-29T00:55:32Z",
    "deviceAssignedDate": "2025-01-29T00:55:32Z"
  }
]
```

### /v1/device-enrollments/1/devices

```shell
jag /v1/device-enrollments/1/devices | jq '.results|map(.syncState.profileUUID)|reduce .[] as $p ({}; .[$p]+=1)'
```

```json
["DEBUG:","api path: /v1/device-enrollments/1/devices"]
["DEBUG:","totalCount: 1914, results: 1914"]
{
  "2A53851A0BC11D856B2E2E85E6B1B69D": 1021,
  "": 216,
  "F2AFD2F9805913C01457B8C08FC40E35": 677
}
```

