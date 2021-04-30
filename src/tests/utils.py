import subprocess
from subprocess import Popen, PIPE


def subprocess_cmds(commands, bash='/run/current-system/sw/bin/zsh'):
    with Popen(bash, stdin=PIPE, stdout=PIPE) as process:
        p_stdout_stderr = process.communicate(commands)

        try:
            stdout = p_stdout_stderr[0].decode()
        except:
            stdout = ''

        try:
            stderr = p_stdout_stderr[1].decode()
        except:
            stderr = ''


        return stdout + stderr
