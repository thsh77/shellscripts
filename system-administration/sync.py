#!/usr/bin/env python
# wraps up rsync to synchronize two directories

import subprocess
import sys
import time

"""this motivated rsync tries to synchronize forever"""

source = "/tmp/sync_dir_A/"
target = "/tmp/sync_dir_B"
rsync = "rsync"
arguments = "-av"
cmd = "%s %s %s %s" % (rsync, arguments, source, target)

def sync():
    while True:
        ret = subprocess.call(cmd, shell=True)
        if ret !=0:
            print("blah")
            time.sleep(30)
        else:
            print("success")
            subprocess.call("mail -s 'jobs done' thsh1977@gmail.com", shell=True)
            sys.exit(0)
sync()