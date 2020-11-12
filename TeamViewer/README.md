# TeamViewer Deployment Script for PSAppDeployToolkit

The ``Deploy-Application.ps1`` script deploy TeamViewer using [PSAppDeployToolkit](https://psappdeploytoolkit.com/).

## File Tree

```
TeamViewer/
├─ TeamViewer_Setup.exe
├─ Deploy-Application.ps1
├─ sfx_listfile.txt
```

## Parameters

The following parameters are available:

Parameter         | Default | Description
----------------- | ------- | -----------
DisableAutoUpdate | False   | Disable TeamViewer auto-update feature (not recommended).

Please see "Toolkit Parameters" at PSAppDeployToolkit documentation for additional parameters.

## Example

To deploy TeamViewer and disable TeamViewer auto-update feature:

```
Deploy-Application.exe -DisableAutoUpdate
```

## SFX Build

You can use the [SFX Build](../) script that parses ``sfx_listfile.txt`` to create an "all-in-one" installer that extracts PSAppDeployToolkit files to the user's temp folder and runs ``Deploy-Application.exe``.
