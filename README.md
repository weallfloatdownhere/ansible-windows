# Ansible-windows

```
rem LicenceFilePath = "C:\ProgramData\chocolatey\lib\chocolatey-license\tools\chocolatey.license.xml"

LicenceFilePath = "C:\Users\anon\Desktop\test.txt"
LicenseDaysLimit = 30

Function DaysBetween(startDate, endDate)
    If Not IsDate(startDate) Or Not IsDate(endDate) Then
        DaysBetween = "Invalid Date"
        Exit Function
    End If
    DaysBetween = DateDiff("d", CDate(startDate), CDate(endDate))
End Function

Function GetLiscenceDateExpiration(liscence_file)
    Dim fso, file, line
	lineNumber = 0
    Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FileExists(liscence_file) Then
        Exit Function
    End If
	Set file = fso.OpenTextFile(liscence_file, 1)
    Do While Not file.AtEndOfStream
        line = file.ReadLine
		lineNumber = lineNumber + 1
        If lineNumber = 2 Then
            ReadSecondLine = line
			GetLiscenceDateExpiration = line
            Exit Do
        End If
    Loop
    file.Close
    Set file = Nothing
    Set fso = Nothing
End Function

Function ExtractDateFromXML(xmlLine)
    Dim regex, matches
    Set regex = New RegExp
    regex.Pattern = "(\d{4}-\d{2}-\d{2}|\d{2}/\d{2}/\d{4}|\d{2}-\d{2}-\d{4})"
    regex.Global = True
    Set matches = regex.Execute(xmlLine)
    If matches.Count > 0 Then
        ExtractDateFromXML = matches(0).Value
    Else
        ExtractDateFromXML = "No date found."
    End If
End Function

Function GetCurrentDate()
    Dim currentDate, formattedDate
    currentDate = Now()
    formattedDate = Year(currentDate) & "-" & _
                    Right("0" & Month(currentDate), 2) & "-" & _
                    Right("0" & Day(currentDate), 2)
    GetCurrentDate = formattedDate
End Function

Function ReturnToCheckMK()
    Dim currentDate, formattedDate
    currentDate = Now()
    formattedDate = Year(currentDate) & "-" & _
                    Right("0" & Month(currentDate), 2) & "-" & _
                    Right("0" & Day(currentDate), 2)
    GetCurrentDate = formattedDate
End Function

Function Main()
	if CInt(DaysBetween(ExtractDateFromXML(GetLiscenceDateExpiration(LicenceFilePath)), GetCurrentDate())) > LicenseDaysLimit then
		WScript.Echo 1
		WScript.Quit 1
	Else
		WScript.Echo 0
		WScript.Quit 0
	End If
End Function

Main()






```

Generic Ansible role dedicated to execute various commons Windows tasks by mostly just providing a set of variables.

# Getting started

To quickly test the role, `create` a new playbook in the role directory with the content below.

*playbook-demo.yml*

```yaml
- name: Common windows tasks executer
  hosts: localhost
  tasks:
    - name: Install Demo
      include_tasks: tasks/main.yml
      vars: { target_product: 'demo', target_version: '10.0.2', extras: { chocolatey: { name: thisisanextra, 
                                                                                        pinned: False, 
                                                                                        state: present, 
                                                                                        timeout: 666, 
                                                                                        version: "69.0.0" } } }
```

Now you can launch the demo playbook using the command below.

```shell
ansible-playbook playbook-demo.yml -i localhost
```


```yaml
jobs:
- chocolatey:
      # Name of the package(s) to be installed.
      name: test1
      # Whether to pin the Chocolatey package or not.
      # If omitted then no checks on package pins are done.
      # Will pin/unpin the specific version if version is set.
      # Will pin the latest version of a package if true, version is not set and and no pin already exists.
      # Will unpin all versions of a package if no and version is not set.
      pinned: False
      # State of the package on the system.
      # When absent, will ensure the package is not installed.
      # When present, will ensure the package is installed.
      # When downgrade, will allow Chocolatey to downgrade a package if version is older than the installed version.
      # When latest or upgrade, will ensure the package is installed to the latest available version.
      # When reinstalled, will uninstall and reinstall the package.
      # Choices:
      #   - "absent"
      #   - "downgrade"
      #   - "upgrade"
      #   - "latest"
      #   - "present" ← (default)
      #   - "reinstalled"
      state: latest
      # Parameters to pass to the package’s chocolateyInstall script.
      # These are parameters specific to the Chocolatey package and are generally documented by the package itself.
      # For parameters that should be passed directly to the underlying installer (for example, MSI installer properties and arguments), use install_args instead.
      package_params: ""
      # These are arguments that are passed directly to the installer run by the Chocolatey package, 
      # for example MSI properties or command-line arguments for the specific native installer used by the package.
      install_args: "/norestart /v /s"
      # These may be any additional parameters to pass through directly to Chocolatey, 
      # in addition to the arguments already specified via other parameters.
      # Passing licensed options may result in them being ignored or 
      # causing errors if the targeted node is unlicensed or missing the chocolatey.extension package.
      choco_args:
       - "--package-parameters-sensitive"

- chocolatey:
      name: test2
      pinned: True
      state: present
      timeout: 2700
      version: "1.0.0"
      ignore_errors: True

- download:
      url: 'http://urldownload2.com'
      destination: "/tmp/destination/"
      force: True
      archive:
        destination: "/tmp/unarchive_destination/"

- download:
      url: 'http://urldownload1.com'
      destination: "destination1"
      force: False
      ignore_errors: True

- regedits:
      name: Language Hotkey
      path: HKCU:\Keyboard Layout\Toggle
      data: 3
      type: dword
      state: present

- regedits:
      name: Language Hotkey
      path: HKCU:\Keyboard Layout\Toggle
      state: absent
      delete_key: yes
      ignore_errors: True

- services:
      name: 'spooler'
      start_mode: 'auto'
      state: 'started'

- shortcut:
      source: /tmp/test.png
      destination: /Desktop/test.png

- reboot:
      timeout: 3600

- win_features:
      name: Net-Framework-Features
      source: C:\Temp\iso\sources\sxs
      state: present
      reboot_if_needed: False
      include_sub_features: False
      include_management_tools: True
      ignore_errors: True

- executables:
      path: 'C:\temp\SQLEXPR_x64_ENU\SETUP.EXE'
      product_id: 'Microsoft SQL Server SQL2019'
      arguments:
        [
          SAPWD=VeryHardPassword,
          /ConfigurationFile=C:\temp\configuration.ini,
        ]
      become: True
      become_method: runas
      become_user: "user"
      become_pass: "password"

- executables:
      path: 'C:\temp\SAMPLE_x64_ENU\SETUP.EXE'
      product_id: 'Microsoft Demo Test'

- delete_file:
      path: 'C:\temp\test.txt'

- firewall_rule:
      name: SMTP
      localport: 25
      action: allow
      direction: in
      protocol: tcp
      state: present
      enabled: yes
      program: any
      ignore_errors: True

- template:
      source: templates/configuration.ini.j2
      destination: "/tmp/configtest.ini"
      owner: bin
      group: wheel
      mode: "0644"
      force: True
      template:
        vars: { test: test, test1: test1, test2: test2 }

- win_dsc:
      resource_name: win_dsc_test
      group_name: test_group
      members:
            - member1
            - member2
            - member3

# These extras vars can be added from anywhere, precedent roles, previously loaded variable, etc.
# In this case, these extras are specified by the `playbook-demo.yml`
- "{{ extras | default({}) }}"

```
