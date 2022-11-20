# Additional Bootstrap Process

This document describes the additional bootstrap process for `blnix`.

This machine is the main backup server i.e. backup target and borgbackup repository host for all the other machines.
It's a cloud hosted VM that has been outfitted with NixOS through [nixos-infect](https://github.com/elitak/nixos-infect).
The goal is to have it fully encrypted, to never let it see any plain text data or metadata and to make it store the backed up data in an encrypted fashion as well.

In its current form, this machine is an OpenVZ VPS which requires some tweaks in order for NixOS to work.
The repective changes have been adapted from the [nixos-openvz](https://github.com/zhaofengli/nixos-openvz) project.
