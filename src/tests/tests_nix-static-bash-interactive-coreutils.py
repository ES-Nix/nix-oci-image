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
    def test_convert_currency_float_value_to_cents_int_input(self):
        """

        """
        # value = 1234
        # expected = 1234
        # self.assertEqual(expected, value)
        # print(os.listdir('/'))
        # print(subprocess.run("ls -ahl", shell=True, check=True))
        #
        # print(os.getenv('PATH'))
        #
        # with Popen(['id'], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
        #
        # with Popen(['file', '--version'], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
        #
        # with Popen(['nix', '--version'], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
        #
        # with Popen(['podman', 'images'], stdout=PIPE) as proc:
        #     print(proc.stdout.read())

        commands = b'''
        echo 'Some string!'         
        python --version
        stat /nix/store 
        '''

        result = subprocess_cmds(commands)
        print(result)

        self.assertIn('Some string!', result)
        self.assertIn('1775', result)
        self.assertIn('Python 3.8.9', result)
        # commands = """nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#python3Minimal --command python --version"""
        # with Popen([commands], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
