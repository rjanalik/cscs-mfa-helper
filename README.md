# cscs-mfa-helper

Helper script to generate CSCS SSH keys.

## Requirements

This script requires a password manager to store login credentials and to generate TOTP code. We use a password manager `pass`, as it is secure (encrypted with GnuPG) and easy to use on command line. But with a little modification of the script you can use your favourite password manager.
If you decide to use different password manager, all you need to do is modifying the function `getCredentials()` accordingly.

On MacOS you can install all requirements with Homebrew:
```bash
brew install gnupg pass pass-otp
```

Clone this repository with submodules:
```bash
git clone --recurse-submodules git@github.com:rjanalik/cscs-mfa-helper.git
```

# Configuration

Next, if you haven't done so already, you have to generate your GnuPG keys, initialize `pass` and save your CSCS credentials.
```bash
# Generate GnuPG keys
gpg --full-gen-key
gpg --edit-key ...
# Initialize pass
pass init ...
# Insert passwrod and TOTP secret to pass
pass insert cscs/<USERNAME>
pass otp append -s -i CSCS cscs/<USERNAME>
```

You have to set your username in the fuction `getCredentials()` in `cscs-mfa-helper.sh`.

For more information about GnuPG, please refer to \
https://www.gnupg.org/gph/en/manual.html#INTRO \
For more information about `pass`, please refer to \
https://www.passwordstore.org/

If you already have TOTP set up in Google Authenticator, you can export the secret as a QR code. Then you can read the QR code with \
https://hub.docker.com/r/dwimberger/qr-api \
https://github.com/dwimberger/qr-api \
and then extract the secret from URI with \
https://github.com/krissrex/google-authenticator-exporter

# Usage

Use this line in your ssh config
```ssh-config
   IdentityFile ~/.ssh/cscs-key
```

When ssh fails to connect, generate new ssh keys with
```bash
<PATH_TO_THE_REPOSITORY>/cscs-mfa-helper/cscs-mfa-helper.sh
```

The script checks if the ssh key is expired (older than 24h). If so, it calls `cscs-keygen.sh` to generate new ssh keys.
It should require only the GnuPG key passphrase.

## TODO

- Call this script automatically from `ssh`.
