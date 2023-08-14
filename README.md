![image](https://github.com/SecureHats/AzWorkspaceManager/assets/40334679/491129ba-6b2d-42b2-a310-7387490ab34c)

[![Maintenance](https://img.shields.io/maintenance/yes/2023.svg?style=flat-square)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)  

[![Good First Issues](https://img.shields.io/github/issues/securehats/AzWorkspaceManager/good%20first%20issue?color=important&label=good%20first%20issue&style=flat)](https://github.com/securehats/AzWorkspaceManager/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22)
[![Needs Feedback](https://img.shields.io/github/issues/securehats/AzWorkspaceManager/needs%20feedback?color=blue&label=needs%20feedback%20&style=flat)](https://github.com/securehats/AzWorkspaceManager/issues?q=is%3Aopen+is%3Aissue+label%3A%22needs+feedback%22)

# Az Workspace Manager (Preview)

## Why this PowerShell Module

Currently the Microsoft Sentinel Workspace Manager (Preview) is only available through the Azure Portal of via de REST API.  
Because the Azure Portal is using API calls in the background, and because the Microsoft Sentinel Workspace Manager API  
contains some errors, I have decided to create a PowerShell Module called **AzWorkspaceManager**

This module is especially useful in scenario's where you want to manage the Workspace Manager using Infrastructure as Code or using pipelines.

## Installation

To get started with this PowerShell module you only need to follow these basic steps.

> Click on the topics below to fold them out.

<details>

<summary>Prerequisites</summary>
<br/>

- [PowerShell Core](https://github.com/PowerShell/PowerShell)
- [Az.Accounts 2.10.0 or higher](https://www.powershellgallery.com/packages/Az.Accounts/2.12.5)
</details>

<details>
 <summary>Install Module</summary>
 
 ```powershell
Install-Module AzWorkspaceManager
 ```
 <br/>

</details>

 ## Get started with the module

This section shows a couple of examples on how to get started with this module.

<details>

<summary>Workspace Manager Configuration</summary>
<br/>

 ### Create a Workspace Manager configuration

Creating a Workspace Manager configuration in the parent Microsoft Sentinel instance.
  ```pwsh
  Add-AzWorkpaceManager -Name 'myWorkspace' -ResourceGroup 'myResourceGroup'
  ```
</br>
</br>

![Add-WorkspaceManager](https://github.com/SecureHats/AzWorkspaceManager/assets/40334679/759beecd-2768-4c74-952f-32b04c34ee2b)


</details>

<details>

<summary>Add Workspace Manager Members and Groups</summary>
<br/>

 ### Add a Workspace Manager Member

Creating Workspace Manager members in the Workspace Manager Configuration.

```pwsh
$arguments = @{
    workspaceName = 'myWorkspace'
    resourceId    = $resourceId
    tenantId      = $tenantId
}

  Add-AzWorkpaceManagerMember @arguments
```
</br>

### Add a Workspace Manager Group

```pwsh
$arguments = @{
    workspaceName           = 'myWorkspace'
    name                    = 'myGroup'
    workspaceManagerMembers = 'mySecondWorkspace(f6426b36-04fa-4a41-a9e4-7f13abe34d55)'
}

  Add-AzWorkpaceManagerGroup @arguments
```
</br>

### Create a member and add through pipeline to group

```pwsh
$arguments = @{
    workspaceName = 'myWorkspace'
    resourceId    = $resourceId
    tenantId      = $tenantId
}

  Add-AzWorkpaceManagerMember @arguments | Add-AzWorkspaceManagerGroup -GroupName 'myGroup'
}

```

![Add-WorkspaceManagerMember-Group](https://github.com/SecureHats/AzWorkspaceManager/assets/40334679/a01048f2-3aca-4d64-bf01-8f0b669269f1)

</details>

<details>

<summary>Add Workspace Manager Assignments</summary>
<br/>

 ### Add a Workspace Manager Assignment

This example creates an empty assignment.  
Because the assignment name is not provided, the 'GroupName' value will be used.

```pwsh
$arguments = @{
    workspaceName = 'myWorkspace'
    groupName     = 'myGroup'
    resourceId    = $resourceId
}

  Add-AzWorkspaceManagerAssignment @arguments
```
</br>

### Add an Alert Rules to a Workspace Manager Assignment  

  This example adds the resourceId of an alert rule to an assignment

```pwsh
$arguments = @{
    workspaceName = 'myWorkspace'
    name          = 'myAssignment'
    groupName     = 'myGroup'
    resourceId    = $resourceId
}

  Add-AzWorkspaceManagerAssignment @arguments
```

### Add Alert Rules to a Workspace Manager Assignment  

  This example gets all saved searches and adds them to an assignment

```pwsh 
$SavedSearches = Get-AzWorkspaceManagerItem -WorkspaceName 'myWorkspace' -Type SavedSearches

$arguments = @{
    workspaceName = 'myWorkspace'
    name          = 'myAssignment'
    groupName     = 'myGroup'
    resourceId    = $SavedSearches.resourceId
}

  Add-AzWorkspaceManagerAssignment @arguments
```
</br>

</details>

<details>

<summary>Create an Assignment Job and get status </summary>
<br/>

 ### Adding a Workspace Manager Assignment Job

Creating a Workspace Manager assignment job.

```pwsh
$arguments = @{
    workspaceName = 'myWorkspace'
    name          = 'myAssignment'
}

  Add-AzWorkspaceManagerAssignmentJob @arguments
```
</br>


### Add a Workspace Manager Assignment Job for all assignments  

  This example creates an assignment job for each Workspace Manager assignment

```pwsh 
$arguments = @{
    workspaceName = 'myWorkspace'
}

  Get-AzWorkspaceManagerAssignment @arguments | Add-AzWorkspaceManagerAssignmentJob
```

### Get all Workspace Manager Assignment Jobs for an assignment  

  This example gets all jobs for a Workspace Manager Assignment

```pwsh 
$arguments = @{
    workspaceName = 'myWorkspace'
    name          = 'myAssignment'
}

  Get-AzWorkspaceManagerAssignmentJob @arguments
```
</br>

</details>

## Community

We all thrive on feedback and community involvement!

**Have a question?** → open a [GitHub issue](https://github.com/SecureHats/AzWorkspaceManager/issues/new/choose).

**Want to get involved?** → Learn how to [contribute](https://github.com/SecureHats/AzWorkspaceManager/blob/main/CONTRIBUTING.md).

## Buy me a Coffee

I am running on coffee and good music when busy writing code. so feel free to buy me a coffee.
  
  
<img src="./media/bmc.png" width="200" height="200" />


## Feedback

If you encounter any issues, have suggestions for improvements or anything else, feel free to open an Issue
I will try to respond to each issue and Pull requests within 48 hours.

[Create Issue](../../issues/new/choose)
