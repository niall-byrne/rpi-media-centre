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

1. [greensheep/plex-server-docker-rpi](https://github.com/greensheep/plex-server-docker-rpi)
    - a dockerized implementation of [Plex](https://www.plex.tv/)
    - facilitates access to your media via the Plex family of native and web applications
2. [crazymax/samba](https://github.com/crazy-max/docker-samba)
   - a dockerized implementation of [Samba](https://www.samba.org/)
   - facilitates loading and downloading media to/from computers and mobile phones
3. [syncthing/syncthing](https://github.com/syncthing/syncthing/blob/main/README-Docker.md)
   - a dockerized implementation of [Syncthing](https://syncthing.net/)
   - a self-hosted Google Drive or Dropbox type file synchronization solution

## How to set this up?

1. Start with a fresh installation of [Raspberry Pi OS](https://www.raspberrypi.com/software/) or similar.
2. Follow [this guide](https://docs.docker.com/engine/install/raspberry-pi-os/) to install docker on your Pi.
    - Pay close attention to first two paragraphs and make sure you follow the correct guide for your version of the OS.
3. Clone this repository onto your Pi's flash card.  Make sure it's not on the external hard drive.

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
4. Create a `.rpi-crypt` file inside the cloned repository containing this UUID:
    - `$ echo "my-uuid-value,media,/mnt/media" > .rpi-crypt`
5. Start the software:
    - `$ ./pictl start`
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
   - `$ echo 'UUID="DISK_UUID_FROM_STEP_3">  /mnt/media  ext4  defaults,nofail,noatime,rw,errors=remount-ro  0  1' | sudo tee -a /etc/fstab`
5. Test your fstab mounts the disk:
   - `$ sudo mount -a`
6. Start the software:
    - `$ ./pictl start`
7. Since the disk is already mounted at the expected mount-point, there is no decryption prompt.  The service can be used immediately.
8. Listen to some music already.

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
   - `$ chmod -R g+rX,g-w /mnt/media/shared/media`

To *keep* this user read-only, avoid creating directories with 'other writable' permissions on your USB disk.  (This includes the infamous `777` permission!)

## Configuration

A series `RPI` prefixed environment variables can be used to customize the behaviour of the managed services.  These values can be stored in an `.rpi` file to persist configuration.

It is imperative to keep this file secure, as it generally will contain sensitive values:
   - `$ chmod 600 .rpi`

### Global Configuration

The [docker-compose.yml](services/docker-compose.yml) is configured by series of `RPI` prefixed environment variables:

| Variable             | Value                                                                                                                                           |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `RPI_RESTART_POLICY` | defaults to `no` (See the [documentation](https://github.com/compose-spec/compose-spec/blob/main/spec.md#restart) for details on this setting.) |
| `RPI_ROOT`           | defaults to `/mnt/media`                                                                                                                        |

Store one or more of these variables as successive lines in the `.rpi` file:

  ```bash
  RPI_RESTART_POLICY="unless-stopped"
  RPI_ROOT="/mnt/my_custom_name"
  ```

### Service Selection

The `.rpi` file can also control *which* services `pictl` manages via a bash array named `RPI_SERVICES`.

By default, this array is set to `("plex" "samba")`, meaning it manages only the Plex and Samba services.  It is possible to control the service selection by defining this array manually in the `.rpi` file:

To enable a single service, such as Plex, add a line like following:

  ```bash
  RPI_SERVICES=("plex")
  ```

To enable multiple services, add them to the array definition as quoted, space separated, strings:

  ```bash
  RPI_SERVICES=("plex" "samba" "syncthing")
  ```

#### Plex Configuration

Plex is generally configured through its web interface, but some settings are able for customization.

| Variable                  | Value                                   |
|---------------------------|-----------------------------------------|
| `RPI_PLEX_PATH_CONFIG`    | default to `${RPI_ROOT}/plex/config`    |
| `RPI_PLEX_PATH_TRANSCODE` | default to `${RPI_ROOT}/plex/transcode` |

These values can be customized by storing one or more of them as successive lines in the `.rpi` file:

  ```bash
  # It may be desirable to move the Plex system files off of your USB drive to allow the disk to sleep.
  # This comes with a series of tradeoffs, including the performance and speed of the system boot disk.
  RPI_PLEX_PATH_CONFIG="${HOME}/.rpi/plex/config"
  RPI_PLEX_PATH_TRANSCODE="${HOME}/.rpi/plex/transcode"
  ```

Plex is an enabled service by default.

#### Samba Configuration

Some Samba settings can be stored in the `.rpi` file to make this service more convenient to use.

| Variable                         | Value                                                             |
|----------------------------------|-------------------------------------------------------------------|
| `RPI_SAMBA_CREDENTIALS_PASSWORD` | managed by `pictl`, but defaults to `nobody` for no-ops           |
| `RPI_SAMBA_CREDENTIALS_USERNAME` | managed by `pictl`, but defaults to `nobody` for no-ops           |
| `RPI_SAMBA_HOSTNAME`             | defaults to the hostname of the Raspberry Pi                      |
| `RPI_SAMBA_PATH_CONFIG`          | default to `${RPI_ROOT}/samba`                                    |
| `RPI_SAMBA_SERVICE_DISCOVERY`    | defaults `1`, but set to `0` to disable Windows service discovery |
| `RPI_SAMBA_SUBNET`               | managed by `pictl`, but defaults to `192.168.0.0/24` for no-ops   |
| `RPI_SAMBA_WORKGROUP`            | defaults to `WORKGROUP`                                           |

These values can be customized by storing one or more of them as successive lines in the `.rpi` file:

  ```bash
  # It may be desirable to move the Samba system files off of your USB drive to allow the disk to sleep.
  # This comes with a series of tradeoffs, including the performance and speed of the system boot disk.
  RPI_SAMBA_PATH_CONFIG="${HOME}/.rpi/samba/config"
  RPI_SAMBA_CREDENTIALS_USERNAME="somebody"
  RPI_SAMBA_CREDENTIALS_PASSWORD="!*secret1234"
  RPI_SAMBA_SERVICE_DISCOVERY="0"
  RPI_SAMBA_SUBNET="172.16.0.0/28"
  RPI_SAMBA_WORKGROUP="MY_WORKGROUP"
  ```

It is also possible to create a completely custom Samba configuration.  Using the [existing config](./services/samba/config.yml) as a template, create a `.rpi-samba.yml` file and customize as needed.  Refer to the [crazymax/samba](https://github.com/crazy-max/docker-samba) repository for details.

Although variable interpolation is available, it is still recommended to keep this custom Samba configuration file secure:
   - `$ chmod 600 .rpi-samba.yml`

Samba is an enabled service by default.

#### Syncthing Configuration

Some Syncthing settings can be stored in the `.rpi` file to make this service more convenient to use.

| Variable                             | Value                                                                                              |
|--------------------------------------|----------------------------------------------------------------------------------------------------|
| `RPI_SYNCTHING_CREDENTIALS_USERNAME` | if defined, Syncthing's web GUI username will be set (or reset) to this value on startup           |
| `RPI_SYNCTHING_CREDENTIALS_PASSWORD` | if defined, Syncthing's web GUI password will be set (or reset) to this value on startup           |
| `RPI_SYNCTHING_PATH_CONFIG`          | default to `${RPI_ROOT}/syncthing`                                                                 |
| `RPI_SYNCTHING_HOSTNAME`             | defaults to `syncthing`, controls the device name other Syncthing clients will see when connecting |

These values can be customized by storing one or more of them as successive lines in the `.rpi` file:

  ```bash
  # It may be desirable to move the Syncthing system files off of your USB drive to allow the disk to sleep.
  # This comes with a series of tradeoffs, including the performance and speed of the system boot disk.
  RPI_SYNCTHING_PATH_CONFIG="${HOME}/.rpi/syncthing/config"
  RPI_SYNCTHING_CREDENTIALS_USERNAME="nobody"
  RPI_SYNCTHING_CREDENTIALS_PASSWORD="v3ryS3cr3t!"
  RPI_SYNCTHING_HOSTNAME="KitchenPi"
  ```

This service is *not* enabled by default.  To use it, add it to an `RPI_SERVICES` array definition in the `.rpi` file

  ```bash
  RPI_SERVICES=("plex" "samba" "syncthing")
  ```
