# passage on WSL

`passage` is a `pass` fork that replaces GPG with `age` for encryption. No agent daemon, no key expiry, no trust model — just an age keypair and a directory of encrypted files.

## Install

```bash
# age
sudo apt install age

# passage (no package — install from source)
git clone https://github.com/FiloSottile/passage ~/.passage-src
sudo make -C ~/.passage-src install
```

## Key setup

```bash
# Generate an age keypair and place it where passage expects it
mkdir -p ~/.age ~/.passage
age-keygen -o ~/.age/key.txt

# The public key is printed to stdout and embedded in key.txt
# Back up ~/.age/key.txt somewhere secure — loss means loss of all secrets

# Copy identity to passage's default location
cp ~/.age/key.txt ~/.passage/identities
```

## Common operations

```bash
passage insert vault/aws/access-key      # prompt for value
passage show vault/aws/access-key        # decrypt to stdout
passage ls                               # list all entries
passage rm vault/aws/access-key
```

## Injecting secrets into CLI commands

```bash
AWS_ACCESS_KEY_ID=$(passage show vault/aws/access-key) aws s3 ls
```

Or export for a session:

```bash
export GITHUB_TOKEN=$(passage show vault/github/token)
```

## Optional: git-backed store

```bash
cd ~/.passage/store
git init
git remote add origin <your-remote>
```

passage will auto-commit on insert/edit/delete. Note: filenames (not values) are visible in git history.
