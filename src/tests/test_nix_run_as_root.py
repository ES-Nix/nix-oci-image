import os
import subprocess
from subprocess import Popen, PIPE

from unittest import TestCase


class UtilsTestCase(TestCase):
    def test_convert_currency_float_value_to_cents_int_input(self):
        """

        """
        value = 1234
        expected = 1234
        self.assertEqual(expected, value)
        print(os.listdir('/'))
        print(subprocess.run("ls -ahl", shell=True, check=True))

        with Popen(["id"], stdout=PIPE) as proc:
            print(proc.stdout.read())

        # with Popen(["/bin/nix --version"], stdout=PIPE) as proc:
        #     print(proc.stdout.read())

        # with Popen(["podman images"], stdout=PIPE) as proc:
        #     print(proc.stdout.read())

        # commands = """nix --experimental-features 'nix-command ca-references flakes' shell nixpkgs#python3Minimal --command python --version"""
        # with Popen([commands], stdout=PIPE) as proc:
        #     print(proc.stdout.read())
