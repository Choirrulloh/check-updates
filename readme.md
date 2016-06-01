Check-Updates
=============

This script is intended to be run as part of an ansible playbook that gathers information on what software packages have outstanding upgrades.

The script should run on any Redhat ( yum ) or Debian ( apt ) based system.


Execution
---------

Obviously this can be run from the command line directly 

or can be executed with wget to post the XML results to a processing system:

```bash
/usr/bin/wget -O /dev/null http://processing.host/path --post-data "$(check-updates.sh)"  --header="Content-Type:application/xml"
```



Output
------

The script will output the following data:

```XML
<?xml version="1.0" encoding="utf-8"?>
<updates> <host>
<name>a</name>
<engine>apt</engine>
<packages>
<package><name>PackageName</name><cur>1.0</cur><next>2.0</next></package>
...
</package>
</host>
</updates>

```

* `engine` - This field may return `apt` or `yum` depending on the system its run on.

* `cur` and `next` - These fields will show the current and upgraded package versions respectivly.


History
-------

This script was generated with some code from the [PatchDashboard](https://github.com/PatchDashboard/patchdashboard) project.
Specifically [this script](https://github.com/PatchDashboard/patchdashboard/blob/master/scripts/patch_checker.sh)


