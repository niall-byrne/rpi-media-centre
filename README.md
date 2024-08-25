# rpi-media-centre

[![cicd-tools](https://img.shields.io/badge/ci/cd:-cicd_tools-blue)](https://github.com/cicd-tools-org/cicd-tools)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)

Encrypt a disk and connect it to your [Raspberry Pi](https://wikipedia.org/wiki/Raspberry_Pi) to host a [plex](https://www.plex.tv/) media server.

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
4. Install the software required for disk encryption:
    - `$ sudo apt-get install -y cryptsetup`
5. Connect and encrypt your external hard drive, keeping the password for your disk in a password manager or suitable external location:
    - `$ sudo cryptsetup luksFormat --type luks2 /dev/DEVICE`
    - `$ sudo cryptsetup luksOpen /dev/DEVICE decrypted_disk`
    - `$ sudo mkfs.ext4 /dev/mapper/decrypted_disk`
    - `$ sudo cryptsetup luksClose /dev/mapper/decrypted_disk`
6. Determine the UUID of the encrypted partition you created:
    - `$ sudo blkid`
7. Create a `.disk` file inside the cloned repository containing this UUID:
    - `$ echo "my-uuid-value" > .disk`
8. Start the software:
    - `$ ./pictl start`
9. Enter the disk encryption password and samba credentials.
10. Listen to some music already.

## What happens when the power goes out?

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
