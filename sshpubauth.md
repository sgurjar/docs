SSH Public Key Authentication
=============================


        client$ mkdir ~/.ssh
        client$ chmod 700 ~/.ssh
        client$ ssh-keygen -q -f ~/.ssh/id_rsa -t rsa
        Enter passphrase (empty for no passphrase): ...
        Enter same passphrase again: ...

        # first, upload public key from client to server
        client$ scp ~/.ssh/id_rsa.pub server.example.org:

        # next, setup the public key on server
        mkdir ~/.ssh
        chmod 700 ~/.ssh
        cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
        chmod 600 ~/.ssh/authorized_keys
        rm ~/id_rsa.pub

