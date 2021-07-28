#!/bin/bash

FILE=go1.16.6.linux-amd64.tar.gz
go version 2> /dev/null
if [ $? -eq "0" ]; then
	GO_INSTALLED=1
	sudo rm -rf /usr/local/go
else
	GO_INSTALLED=0
fi

wget https://golang.org/dl/$FILE
sudo tar -C /usr/local -xzf $FILE
rm $FILE

if [ $GO_INSTALLED -eq "0" ]; then
	echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
fi

/usr/local/go/bin/go version

echo "Go should be installed. Run 'source ~/.profile' to start using it"
