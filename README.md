bash-utils
==========

Some bash utility functions.

Just to get things straight, I am not a fan of bash scripts and I would resort to anything more high-level like Java or Python for doing something complex. However, there are some applications (and constraints) for which bash scripts are more suited.

For instance, for my diploma thesis I had to run some R program in parallel. I could have done this in R itself as there are numerous packages for that, but I wanted to run the program on univeristy computers and I cannot just install an R package  there. That is why I wrote a little bash process management script.

# Idioms

For the sake of documentation (as I am quite forgetful) and for sharing with bash novices, I am going to jot down some bash idioms that proved quite useful. 

## Working with files

### Strip directory, filebasename and fileextension from an absolute path to a file

```bash
FILE_PATH=/a/b/filename.ext
DIRECTORY=$(dirname $FILE_PATH) # yiels /a/b
FILENAME=$(basename $FILE_PATH) # yields filename.ext
FILEBASENAME=${FILENAME%.*} # yields filename
FILEEXT=${FILENAME##*.} -> ext
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
As this will launch a login shell, it will feel most naturally, since all environment variables you are accustomed to will be present
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

# If the job fails, send an email with the job's output
```bash
$CMD || mail -s $SUBJECT $MAIL_ADDR
```
