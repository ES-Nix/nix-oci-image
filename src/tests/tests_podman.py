import os
import subprocess
from subprocess import Popen, PIPE

from unittest import TestCase


def subprocess_cmds(commands, bash='/bin/sh'):
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


class UtilsTestCase(TestCase):
    def test_podman(self):
        """

        """
        commands = b'''
        podman --version
        hello
        '''

        result = subprocess_cmds(commands)

        self.assertIn('Hello, world!\n', result)
        self.assertIn('podman version 3.0.1', result)

        # commands = """nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#python3Minimal --command python --version"""
        # with Popen([commands], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
