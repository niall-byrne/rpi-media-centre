# rpi-media-centre

[![cicd-tools](https://img.shields.io/badge/ci/cd:-cicd_tools-blue)](https://github.com/cicd-tools-org/cicd-tools)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

Connect an external disk to your [Raspberry Pi](https://wikipedia.org/wiki/Raspberry_Pi) to host a [Plex](https://www.plex.tv/) media server, and some other useful software/

## Builds

| Branch                                                            | Build                                                                                                                                                                                                                                      |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [main](https://github.com/niall-byrne/rpi-media-centre/tree/main) | [![rpi-media-centre-github-workflow-push](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml/badge.svg?branch=main)](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml) |
| [dev](https://github.com/niall-byrne/rpi-media-centre/tree/dev)   | [![rpi-media-centre-github-workflow-push](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml/badge.svg?branch=dev)](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml)  |

## Components

### Hardware

This project requires the following hardware:

1. All documentation seems to suggest a [Raspberry Pi 3](https://wikipedia.org/wiki/Raspberry_Pi) or better to host [Plex](https://www.plex.tv/) with decent performance.
2. A USB hard drive works fine.  I've repurposed an old school Western Digital with spinning platters.

### Software

This project combines the following software:

1. [pihole/pihole](https://github.com/pi-hole/pi-hole)
   - a managed ad-blocking DNS server
   - an optional managed DHCP server for your local LAN
2. [greensheep/plex-server-docker-rpi](https://github.com/greensheep/plex-server-docker-rpi)
   - a dockerized implementation of [Plex](https://www.plex.tv/)
   - facilitates access to your media via the Plex family of native and web applications
3.[crazymax/samba](https://github.com/crazy-max/docker-samba)
   - a dockerized implementation of [Samba](https://www.samba.org/)
   - facilitates loading and downloading media to/from computers and mobile phones
4.[syncthing/syncthing](https://github.com/syncthing/syncthing/blob/main/README-Docker.md)
   - a dockerized implementation of [Syncthing](https://syncthing.net/)
   - a self-hosted Google Drive or Dropbox type file synchronization solution

## How to set this up?

1. Start with a fresh installation of [Raspberry Pi OS](https://www.raspberrypi.com/software/) or similar.
2. Follow [this guide](https://docs.docker.com/engine/install/raspberry-pi-os/) to install docker on your Pi.
    - Pay close attention to first two paragraphs and make sure you follow the correct guide for your version of the OS.
3. Clone this repository onto your Pi's flash card.  Make sure it's not on the external hard drive.
4. Optionally, there are a few binaries you can install to extend the functionality of this project, most are likely already installed:
   - "$ sudo apt-get install rsync tree vim"

## With Disk Encryption
1. Install the software required for disk encryption:
    - `$ sudo apt-get install -y cryptsetup`
2. Connect and encrypt your external hard drive, keeping the password for your disk in a password manager or suitable external location:
    - `$ sudo cryptsetup luksFormat --type luks2 /dev/DEVICE`
    - `$ sudo cryptsetup luksOpen /dev/DEVICE decrypted_disk`
    - `$ sudo mkfs.ext4 /dev/mapper/decrypted_disk`
    - `$ sudo cryptsetup luksClose /dev/mapper/decrypted_disk`
3. Determine the UUID of the encrypted partition you created:
    - `$ sudo blkid`
4. Create a `/etc/rpi/crypt` file inside the cloned repository containing this UUID:
    - `$ sudo mkdir -p /etc/rpi`
    - `$ sudo ./pictl disk manifest edit`
    - Create a line in the file that looks something like:
       >  uuid_value_from_blkid,media_disk,media_disk_group,/mnt/media
5. Start the software:
    - `$ sudo ./pictl service start`
6. Enter the disk encryption password and Samba credentials.
7. Listen to some music already.

## Without Disk Encryption
1. Connect and format your external drive:
   - `$ sudo mkfs.ext4 /dev/DEVICE`
2. Create the mount-point:
   - `$ sudo mkdir -p /mnt/media`
3. Determine the UUID of your newly formatted disk:
   - `$ sudo blkid`
4. Add the external hard drive to `/etc/fstab` to that the OS manages mounting it for you:
   - `$ echo 'UUID="DISK_UUID_FROM_STEP_3"  /mnt/media  ext4  defaults,nofail,noatime,rw,errors=remount-ro  0  1' | sudo tee -a /etc/fstab`
5. Test your fstab mounts the disk:
   - `$ sudo mount -a`
6. Start the software:
   - `$ sudo ./pictl service start`
7. Since the disk is already mounted at the expected mount-point, there is no decryption prompt.  The service can be used immediately.
8. Listen to some music already.

## What is "Single User Mode"?

Cloning this repository to your home folder and running it violates a few best-practices for managing a linux system.  System-wide software generally isn't meant to run this way, it *can* work, but it isn't recommended.

If you are the only administrator of your Raspberry Pi, then is likely *not* going to be a problem, and you can safely [disable this warning](#global-configuration) and enjoy your media centre.  However, you may want to read on first.

### Setting up a Service Account

The alternative to this type of setup is to use a [service account](https://unix.stackexchange.com/questions/314725/what-is-the-difference-between-user-and-service-account) to provide separation between yourself as an administrator of the Raspberry Pi, and the data and services your media centre provides.  This separation provides greater security, and allows multiple administrative accounts to interact with `pictl` without creating conflicts.

There are two requirements for setting up a service account with `pictl`:

1. There is some extra [global configuration](#global-configuration) required have `pictl` provision a service account for you. This is fairly straightforward, and the bare minimum needed is just to supply a value for the `RPI_SVC_USERNAME` configuration variable.  If you do this, `pictl` will create the service account for you-- even if you just execute `$ ./pictl help`.
2. You need to have you media files owned by this new service account, and not by your Raspberry Pi user: If your disk is mounted at `/mnt/media`, then this could be done with the command:
   - `$ chown <service_account_username>:<service_account_groupname> -R /mnt/media/shared`

You can still interact with your media as an administrator by using `sudo` to:
  - Assume the service accounts identity `sudo -u <service_account_username> bash`.
  - To copy or move files, while retaining their service account ownership.

## What are the pros and cons to using disk encryption?

If someone swipes your disk it's useless to them.  There is no trace of the credentials on the Pi or disk itself.

There's a trade off to this security though …

After a power outage, or if you physically unplug your media centre, you will need to ssh back into your Pi and restart the server:
- This means re-entering the passwords for the encrypted disk and Samba.  Keep these passwords in a safe spot, such as a password manager.
- Don't use a password to connect to your Pi- do this securely by setting up [ssh keys](https://www.raspberrypi.com/documentation/computers/remote-access.html#ssh).

## Loading Media onto a Mobile Phone

The created Samba shares will be accessible by two users:
  - The user configured by the `pictl` command.
  - A second `android` user, that uses the same password.

This is intended to provide a mechanism for loading media onto a mobile phone.

This requires the installation of a Samba compatible app on the phone, but there are several good ones out there.
(I am personally quite found of [Cx File Explorer](https://play.google.com/store/apps/details?id=com.cxinventor.file.explorer) right now.)

The `android` user provides read-only access to your media, just to prevent any accidental deletion.  This works by granting `android` read only access to the media files via the `group` attribute, but this must be enforced on the file system:
   - `$ chmod -R g+rX,g-w,o-rwx /mnt/media/shared/media`

To *keep* this user read-only, avoid creating directories with 'other writable' permissions on your USB disk.  (This includes the infamous `777` permission!)

## Configuration

A series `RPI` prefixed environment variables can be used to customize the behaviour of the managed services.  These values can be stored in an `/etc/rpi/config` file to persist configuration.

It is imperative to keep this file secure, as it generally will contain sensitive values:
   - `$ sudo chmod 600 /etc/rpi/config`

### Global Configuration

The [docker-compose.yml](services/docker-compose.yml) is configured by series of `RPI` prefixed environment variables:

| Variable                                       | Value                                                                                                                                                                           |
|------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `RPI_DISABLE_SINGLE_USER_MODE_WARNING_BOOLEAN` | unset by default, this can be configured to `1` to disable the [single user mode](#what-is-single-user-mode) warning                                                            |
| `RPI_HOST_IP`                                  | defaults to the first ip address found with `hostname -I` or will fallback to `127.0.0.1`                                                                                       |
| `RPI_HOST_TZ`                                  | defaults to the contents of `/etc/timezone` or will fallback to `UTC` (See this [article](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for a list of options.) |
| `RPI_MANIFEST_EDITOR`                          | defaults to `/usr/bin/vi`                                                                                                                                                       |
| `RPI_RESTART_POLICY`                           | defaults to `no` (See the [documentation](https://github.com/compose-spec/compose-spec/blob/main/spec.md#restart) for details on this setting.)                                 |
| `RPI_ROOT`                                     | defaults to `/mnt/media`                                                                                                                                                        |
| `RPI_SVC_GID`                                  | defaults to the `gid` associated with `RPI_SVC_GROUPNAME`                                                                                                                       |                                                                                      |
| `RPI_SVC_GROUPNAME`                            | defaults to the group of the current user                                                                                                                                       |
| `RPI_SVC_UID`                                  | defaults to the `uid` associated with `RPI_SVC_USERNAME`                                                                                                                        |
| `RPI_SVC_USERNAME`                             | defaults to the current user's username                                                                                                                                         |
| `RPI_SVC_UID_RO`                               | defaults to the first unused `uid` on your Raspberry Pi, used by Samba as the `uid` of the read-only `android` user                                                             |

Store one or more of these variables as successive lines in the `/etc/rpi/config` file:

  ```bash
  RPI_HOST_IP="192.168.1.10"
  RPI_HOST_TZ="America/Toronto"
  RPI_MANIFEST_EDITOR="/usr/bin/nano"
  RPI_RESTART_POLICY="unless-stopped"
  RPI_ROOT="/mnt/my_custom_name"
  RPI_SVC_GID="1005"
  RPI_SVC_GROUPNAME="nas"
  RPI_SVC_UID="1005"
  RPI_SVC_UID_RO="1001"
  RPI_SVC_USERNAME="nas"
  ```

### Service Selection

The `/etc/rpi/config` file can also control *which* services `pictl` manages via a bash array named `RPI_SERVICES`.

By default, this array is set to `("plex" "samba")`, meaning it manages only the Plex and Samba services.  It is possible to control the service selection by defining this array manually in the `/etc/rpi/config` file:

To enable a single service, such as Plex, add a line like following:

  ```bash
  RPI_SERVICES=("plex")
  ```

To enable multiple services, add them to the array definition as quoted, space separated, strings.

All services can be enabled with the following:

  ```bash
  RPI_SERVICES=("pihole" "plex" "samba" "syncthing")
  ```

#### Event Scripts

There are optional shell scripts that can be created and executed when `pictl` encounters specific events.

| Script Path                                        | Event                                             |
|----------------------------------------------------|---------------------------------------------------|
| `/etc/rpi/events/event-backup-scheduler-after.sh`  | executed after the backup scheduler finishes      |
| `/etc/rpi/events/event-backup-scheduler-before.sh` | executed before the backup scheduler starts       |
| `/etc/rpi/events/event-backup-scheduler-error.sh`  | executed on a fatal scheduler error               |
| `/etc/rpi/events/event-backup-job-task-after.sh`   | executed after a backup job task finishes         |
| `/etc/rpi/events/event-backup-job-task-before.sh`  | executed before a backup job task starts          |
| `/etc/rpi/events/event-backup-job-task-error.sh`   | executed on a backup job task error               |
| `/etc/rpi/events/event-disk-after-mounted.sh`      | executed after all encrypted disks are mounted    |
| `/etc/rpi/events/event-disk-before-mounted.sh`     | executed before all encrypted disks are mounted   |
| `/etc/rpi/events/event-disk-after-unmounted.sh`    | executed after all encrypted disks are unmounted  |
| `/etc/rpi/events/event-disk-before-unmounted.sh`   | executed before all encrypted disks are unmounted |

This is particularly useful for maintaining specific file permissions on the shared media.

If one wanted to ensure the Samba permissions were correct on `/mnt/media/shared` this `/etc/rpi/events/event-disk-after-mounted.sh` script could be useful:

   ```bash
   #!/bin/bash
   chmod -R u+rwX,g+rX,g-w,o-rwx /mnt/media/shared/media
   ```

This grants full read and write access to all shared media files to the owner, read only access to the group, and no access to other users.

This would work in tandem with the default Samba configuration to ensure the `android` user has read only access, and deny access to other users.  Permissions might change when loading files over `rsync` or methods other than Samba, so the periodic execution of this script could be useful during disk mounts.

It is recommended to keep these event scripts secure and executable:
   - `$ chmod 700 /etc/rpi/events/event-disk-after-mounted.sh`

#### Pi-hole Configuration

Pi-hole is generally configured through its web interface, but some settings are able for customization.

| Variable                          | Value                                                   |
|-----------------------------------|---------------------------------------------------------|
| `RPI_PIHOLE_CREDENTIALS_PASSWORD` | managed by `pictl`, but defaults to `nobody` for no-ops |
| `RPI_PIHOLE_PATH_CONFIG`          | defaults to `${RPI_ROOT}/pihole/config`                 |
| `RPI_PIHOLE_PATH_DNSMASQ`         | defaults to `${RPI_ROOT}/pihole/dnsmasq`                |

These values can be customized by storing one or more of them as successive lines in the `/etc/rpi/config` file:

  ```bash
  RPI_PIHOLE_CREDENTIALS_PASSWORD="!*secret1234"
  RPI_PIHOLE_PATH_CONFIG="/var/local/rpi/pihole/config"
  RPI_PIHOLE_PATH_DNSMASQ="/var/local/rpi/pihole/dnsmasq"
  ```

This service is *not* enabled by default.  To use it, add it to an `RPI_SERVICES` array definition in the `/etc/rpi/config` file

  ```bash
  RPI_SERVICES=("pihole" "plex" "samba")
  ```

#### Plex Configuration

Plex is generally configured through its web interface, but some settings are able for customization.

| Variable                         | Value                                        |
|----------------------------------|----------------------------------------------|
| `RPI_PLEX_PATH_CONFIG`           | default to `${RPI_ROOT}/plex/config`         |
| `RPI_PLEX_PATH_DATA_MOUNT_1`     | defaults to `${RPI_ROOT}/shared/media:/data` |
| `RPI_PLEX_PATH_DATA_MOUNT_[2-9]` | defaults to null mounts                      |
| `RPI_PLEX_PATH_TRANSCODE`        | default to `${RPI_ROOT}/plex/transcode`      |

These values can be customized by storing one or more of them as successive lines in the `/etc/rpi/config` file:

  ```bash
  RPI_PLEX_PATH_CONFIG="/var/local/rpi/plex/config"
  RPI_PLEX_PATH_DATA_MOUNT_2="/mnt/disk2:/disk2"  # Exposes a second disk to Plex
  RPI_PLEX_PATH_TRANSCODE="/var/local/rpi/plex/transcode"
  ```

Plex is an enabled service by default.

#### Samba Configuration

Some Samba settings can be stored in the `/etc/rpi/config` file to make this service more convenient to use.

| Variable                          | Value                                                             |
|-----------------------------------|-------------------------------------------------------------------|
| `RPI_SAMBA_CREDENTIALS_PASSWORD`  | managed by `pictl`, but defaults to `nobody` for no-ops           |
| `RPI_SAMBA_CREDENTIALS_USERNAME`  | managed by `pictl`, but defaults to `nobody` for no-ops           |
| `RPI_SAMBA_PATH_DATA_MOUNT_1`     | defaults to `${RPI_ROOT}/shared/media:/samba/media`               |
| `RPI_SAMBA_PATH_DATA_MOUNT_2`     | defaults to `${RPI_ROOT}/shared/transfer:/samba/transfer`         |
| `RPI_SAMBA_PATH_DATA_MOUNT_3`     | defaults to `${RPI_ROOT}/shared/syncthing:/samba/syncthing`       |
| `RPI_SAMBA_PATH_DATA_MOUNT_[4-9]` | defaults to null mounts                                           |
| `RPI_SAMBA_HOSTNAME`              | defaults to the hostname of the Raspberry Pi                      |
| `RPI_SAMBA_PATH_CONFIG`           | default to `${RPI_ROOT}/samba`                                    |
| `RPI_SAMBA_SERVICE_DISCOVERY`     | defaults `1`, but set to `0` to disable Windows service discovery |
| `RPI_SAMBA_SUBNET`                | managed by `pictl`, but defaults to `192.168.0.0/24` for no-ops   |
| `RPI_SAMBA_WORKGROUP`             | defaults to `WORKGROUP`                                           |

These values can be customized by storing one or more of them as successive lines in the `/etc/rpi/config` file:

  ```bash
  RPI_SAMBA_CREDENTIALS_USERNAME="somebody"
  RPI_SAMBA_CREDENTIALS_PASSWORD="!*secret1234"
  RPI_SAMBA_PATH_CONFIG="/var/local/rpi/samba/config"
  RPI_SAMBA_PATH_DATA_MOUNT_4="/mnt/disk2:/disk2"  # Exposes a second disk to Samba
  RPI_SAMBA_SERVICE_DISCOVERY="0"
  RPI_SAMBA_SUBNET="172.16.0.0/28"
  ```

It is also possible to create a completely custom Samba configuration.  Using the [existing config](./services/samba/config.yml) as a template, create a `/etc/rpi/samba.yml` file and customize as needed.  Refer to the [crazymax/samba](https://github.com/crazy-max/docker-samba) repository for details.

Although variable interpolation is available, it is still recommended to keep this custom Samba configuration file secure:
   - `$ chmod 600 /etc/rpi/samba.yml`

Samba is an enabled service by default.

#### Syncthing Configuration

Some Syncthing settings can be stored in the `/etc/rpi/config` file to make this service more convenient to use.

| Variable                              | Value                                                                                              |
|---------------------------------------|----------------------------------------------------------------------------------------------------|
| `RPI_SYNCTHING_CREDENTIALS_USERNAME`  | if defined, Syncthing's web GUI username will be set (or reset) to this value on startup           |
| `RPI_SYNCTHING_CREDENTIALS_PASSWORD`  | if defined, Syncthing's web GUI password will be set (or reset) to this value on startup           |
| `RPI_SYNCTHING_PATH_DATA_MOUNT_1`     | defaults to `${RPI_ROOT}/shared/syncthing:/var/syncthing`                                          |
| `RPI_SYNCTHING_PATH_DATA_MOUNT_[2-9]` | defaults to null mounts                                                                            |
| `RPI_SYNCTHING_PATH_CONFIG`           | default to `${RPI_ROOT}/syncthing`                                                                 |
| `RPI_SYNCTHING_HOSTNAME`              | defaults to `syncthing`, controls the device name other Syncthing clients will see when connecting |

These values can be customized by storing one or more of them as successive lines in the `/etc/rpi/config` file:

  ```bash
  RPI_SYNCTHING_CREDENTIALS_USERNAME="nobody"
  RPI_SYNCTHING_CREDENTIALS_PASSWORD="v3ryS3cr3t!"
  RPI_SYNCTHING_PATH_CONFIG="/var/local/rpi/syncthing/config"
  RPI_SYNCTHING_PATH_DATA_MOUNT_2="/mnt/disk2:/disk2"  # Exposes a second disk to Syncthing
  RPI_SYNCTHING_HOSTNAME="KitchenPi"
  ```

This service is *not* enabled by default.  To use it, add it to an `RPI_SERVICES` array definition in the `/etc/rpi/config` file

  ```bash
  RPI_SERVICES=("plex" "samba" "syncthing")
  ```

### Backup System Configuration

A comprehensive backup system is also included, and can be configured to make periodic backups of data stored on your disks.

This involves the creation of a backup manifest file, which groups lists of backup jobs by their frequency.

Some settings can be stored in the `/etc/rpi/config` file to make this service more convenient to use.

| Variable                          | Value                                                                                                                                                                                                                  |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `RPI_BACKUP_SCHEDULER_END_TIME`   | defaults to `06:00:00` (6 AM)<br />-  this is the time (on a 24 hour clock) when no further backup jobs are able to be started (any leftover jobs will instead be run the next time the backup scheduler window opens) |
| `RPI_BACKUP_SCHEDULER_START_TIME` | defaults to `00:00:00` (midnight)<br />-  this is the time (on a 24 hour clock) each day that the backup job scheduler starts executing jobs                                                                           |
| `RPI_BACKUP_SCHEDULING_HOUR`      | defaults to `12` (noon)<br />- this is the hour (on a 24 hour clock), (NOT A COMPLETE TIME) each day when backup jobs are scheduled by checking the manifest                                                           |

#### Backup System Installation

In order to use the backup system, you absolutely **must** complete the `pictl` install process:
- `$ sudo ./pictl install pictl`

This process will:
- clone an independent *centralized* copy of `pictl` to `/var/local/rpi/source`
- install a system-wide start shim to `/usr/local/sbin/pictl` (which is normally already present in PATH)
- install two backup related systemd services, and a scheduling crontab

This tends to make for a more secure, cleaner and simpler to manage installation.  It's also prudent to remove the existing local copy of the repository to eliminate duplication.

The new centrally installed CLI can be accessed by executing:
- `$ sudo pictl`

To *update* an existing installation, just run this process again:
- `$ sudo pictl install pictl`

#### Supported Backup Job Tasks

Each backup job will perform one or more backup tasks.

| Type    | Description                                                                                               |
|---------|-----------------------------------------------------------------------------------------------------------|
| rsync   | duplicate data between two file system locations locally                                                  |
| tarball | create local tar archives of data                                                                         |
| upload  | upload local tar archives to cloud storage (currently only [S3](https://aws.amazon.com/s3/) is supported) |

#### Supported Backup Job Frequencies

Backup jobs are all designed to executed at the same time, which is configured by the `RPI_BACKUP_SCHEDULER_START_TIME` environment variable.  The days each specific job are executed is controlled by their frequency group in the backup manifest file.

| Frequency  | Description                                                                            |
|------------|----------------------------------------------------------------------------------------|
| daily      | performed each day                                                                     |
| even       | performed on even days of the year (1-325/6)                                           |
| odd        | performed on odd days of the year (1-325/6)                                            |
| SUN…SAT    | performed on the specified day (identified by it's 3 character abbreviation) each week |
| biweekly   | performed on both Monday and Thursday every week                                       |
| monthly    | performed on the 1st of each month                                                     |
| bimonthly  | performed on both the 1st and 15th of each month                                       |
| quarterly  | performed every 3 months, on the 1st of the month                                      |
| biannually | performed every 6 months, on the 1st of the month                                      |

#### The Backup Manifest File

The backup manifest file is stored at `/etc/rpi/backup`, and has locked down permissions to avoid tampering.

To create backup jobs, it's best to use the `pictl` CLI itself to edit the manifest file, as it's quite complicated, and the CLI provides both validation and ensures file permissions are handled securely.  It's recommended to execute:
- `$ sudo pictl backup manifest edit`

The file itself is admittedly a bit cumbersome as it's still just a comma separated text file.  (YAML might be a preferable future improvement.)

The CLI is also the best source of details for how to structure each job (which may include 1 or more backup tasks).  For full details it's recommended to execute:
- `$ sudo pictl backup manifest details`
