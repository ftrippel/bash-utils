bash-utils
==========

Some bash utility functions.

Just to get things straight, I am not a fan of bash scripts and I would resort to anything more high-level like Java or Python for doing something complex. However, there are some applications for which bash scripts are more suited.

# Contents

<dl>
  <dt>process.sh</dt>
  <dd>A bash framework for running processes.</dd>
</dl>

# Idioms

For the sake of documentation (as I am quite forgetful) and for sharing with _bash novices_, I am going to jot down some bash idioms that I find quite useful.

## Working with files

### Strip directory, file basename and extension from an absolute file path

```bash
FILE_PATH=/a/b/filename.ext
DIRECTORY=$(dirname $FILE_PATH) # yiels "/a/b"
FILENAME=$(basename $FILE_PATH) # yields "filename.ext"
FILEBASENAME=${FILENAME%.*} # yields "filename"
FILEEXT=${FILENAME##*.} -> # yields "ext"
```

### Determine the file owner
```bash
FILE_OWNER=$(stat -c '%U' $FILE)
```

### Determine the full path of the executed bash script
```bash
SCRIPT_PATH=`readlink -f $0`
```

### Working with PIDFILES
```bash
# Write a PIDFILE
echo \$! > $PIDFILE

# Read a PIDFILE
PID=$(<"$PIDFILE")

# Check if PIDFILE exists
if [ -f "$PIDFILE" ]; then
...
fi
```

## Working with processes

### Execute a series of commands as particular user including root
As this will launch a login shell, it will feel most natural, since all environment variables you are accustomed to will be present
```bash
sudo su --login $USER -s /bin/bash <<EOF
...
EOF
```

### Start a job in the background and detach
```bash
$CMD &
disown %1
```

### If the command CMD fails, send an email
```bash
TMP=`mktemp /tmp/temporary-file.XXXXX`
($CMD | tee $TMP) || (cat $TMP | mail -s $SUBJECT $MAIL_TO)
```
