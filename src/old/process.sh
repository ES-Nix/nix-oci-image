
# See https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
#set -euxo pipefail

set -e


nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay
result/bin/cowsay 'Hi!'
rm result
nix --experimental-features 'nix-command ca-references flakes' store gc

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
build \
nixpkgs#cowsay

rm result

ls -al /home/nixuser

nix \
--experimental-features \
'nix-command ca-references flakes' \
--store /home/nixuser \
store \
gc

cd /home/nixuser/nix/store/
rm -rf *
cd /

cd /home/nixuser/nix/var/
rm -rf *
cd /


stat /home/nixuser
chmod 0755 -R /home/nixuser
chmod 0700 /home/nixuser
chown nix_user:nix_group -R /home/nixuser

stat /home/nixuser

ls -al

rm -rf /.cache

cd /tmp
rm -rf *

cd /

#rm -r /nix



#nix --experimental-features 'nix-command ca-references flakes' build nixpkgs#cowsay
#result/bin/cowsay 'Hi!'
#rm result
#nix --experimental-features 'nix-command ca-references flakes' store gc
