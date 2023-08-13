![logo](./media/sh-banner.png)
=========
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

## Common setup

To get started with this PowerShell module you only need to follow these basic steps.

### Prerequisites

- [PowerShell Core](https://github.com/PowerShell/PowerShell)
- [Az.Accounts 2.10.0 or higher](https://www.powershellgallery.com/packages/Az.Accounts/2.12.5)

Installing the module  

  ```powershell
  Install-Module -AzWorkspaceManager
  ```

<!-- This SecureHats repository is used to organize project information and artifacts. 
> Note field
- [ ] unchecked
- [x] checked
```Pwsh
Code example
```
## Heading 2
### Heading 3
#### Heading 4
_italic_
**bold**
inline `code-example` 
 -->

## Buy me a Coffee

I am running on coffee and good music when busy writing code. so feel free to buy me a coffee.
  
  
<img src="./media/bmc.png" width="200" height="200" />


## Not happy?

If you encounter any issues, or have suggestions for improvements, feel free to open an Issue

[Create Issue](../../issues/new/choose)
