# rpi-media-centre

[![cicd-tools](https://img.shields.io/badge/ci/cd:-cicd_tools-blue)](https://github.com/cicd-tools-org/cicd-tools)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

Connect an external disk to your [Raspberry Pi](https://wikipedia.org/wiki/Raspberry_Pi) to host a [plex](https://www.plex.tv/) media server.

## Builds

| Branch                                                            | Build                                                                                                                                                                                                                                      |
|-------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [main](https://github.com/niall-byrne/rpi-media-centre/tree/main) | [![rpi-media-centre-github-workflow-push](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml/badge.svg?branch=main)](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml) |
| [dev](https://github.com/niall-byrne/rpi-media-centre/tree/dev)   | [![rpi-media-centre-github-workflow-push](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml/badge.svg?branch=dev)](https://github.com/niall-byrne/rpi-media-centre/actions/workflows/workflow-push.yml)  |

## Components

### Hardware

This project requires the following hardware:

1. All documentation seems to suggest a [Raspberry Pi 3](https://wikipedia.org/wiki/Raspberry_Pi) or better to host [plex](https://www.plex.tv/) with decent performance.
2. A USB hard drive works fine.  I've repurposed an old school Western Digital with spinning platters.

### Software

This project combines the following software:

1. [greensheep/plex-server-docker-rpi](https://github.com/greensheep/plex-server-docker-rpi)
    - a dockerized implementation of [plex](https://www.plex.tv/)
    - facilitates access to your media via the plex family of native and web applications.
2. [crazymax/samba](https://github.com/crazy-max/docker-samba)
   - a dockerized implementation of [samba](https://www.samba.org/)
   - facilitates loading and downloading media to/from computers and mobile phones

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
4. Create a `.disk` file inside the cloned repository containing this UUID:
    - `$ echo "my-uuid-value" > .disk`
5. Start the software:
    - `$ ./pictl start`
6. Enter the disk encryption password and samba credentials.
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
- This means re-entering the passwords for the encrypted disk and samba.  Keep these passwords in a safe spot, such as a password manager.
- Don't use a password to connect to your Pi- do this securely by setting up [ssh keys](https://www.raspberrypi.com/documentation/computers/remote-access.html#ssh).

## Loading Media onto a Mobile Phone

The created samba shares will be accessible by two users:
  - The user configured by the `pictl` command.
  - A second `android` user, that uses the same password.

This is intended to provide a mechanism for loading media onto a mobile phone.

This requires the installation of a samba compatible app on the phone, but there are several good ones out there.
(I am personally quite found of [Cx File Explorer](https://play.google.com/store/apps/details?id=com.cxinventor.file.explorer) right now.)

The `android` user provides read-only access to your media, just to prevent any accidental deletion.  This works by granting `android` read only access to the media files via the `group` attribute, but this must be enforced on the file system:
   - `$ chmod -R g+rX,g-w /mnt/media/shared/media`

To *keep* this user read-only, avoid creating directories with 'other writable' permissions on your USB disk.  (This includes the infamous `777` permission!)

## Advanced Docker Usage

It is possible to customize the container [restart-policy](https://github.com/compose-spec/compose-spec/blob/main/spec.md#restart) and the main disk mount point.

The [docker-compose.yml](services/docker-compose.yml) is configured by series of `RPI` prefixed environment variables:
  - `RPI_MOUNT_POINT`: defaults to `/mnt/media`
  - `RPI_RESTART_POLICY`: defaults to `no`

These values can be customized by either:
  - Passing them through on the command line: `$ RPI_MOUNT_POINT="/mnt/my_custom_name" ./pictl start`
  - Storing them as successive lines in a `.env` file:

     ```bash
       RPI_MOUNT_POINT="/mnt/my_custom_name"
       RPI_RESTART_POLICY="unless-stopped"
     ```
