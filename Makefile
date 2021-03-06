CC = gcc
LD = gcc

B64DIR = ./base64
BSTRDIR = ./bstrlib
ONERING = ./oneringtorulethemail
GOLLUM = ./gollum
TESTTMP = ./test/tmp
INCLUDES = -I$(BSTRDIR) -I$(B64DIR) -I./
B64OBJS = base64.o
BSTROBJS = bstrlib.o bstrlibext.o
DEFINES =
LFLAGS = -L/usr/lib/ -L./bstrlib -L./base64 -lm -lssl -lcrypt -lcrypto
CFLAGS = -O3 -Wall -pedantic -ansi -s $(DEFINES) -std=c99 -g -D_GNU_SOURCE

install: install-test
	rm -f $(TESTTMP)/creds.txt
	sudo rm -f $(TREE)/server/bin/boromailutils $(TREE)/server/bin/faramailutils
	sudo rm -f $(TREE)/client/bin/gollumutils

install-test: install-unpriv server client gen-certs install-priv 

install-unpriv:
	./install-unpriv.sh $(TREE)

install-priv:
	sudo ./install-priv.sh $(TREE)

gen-certs:
	sudo ./gen-certs.sh $(TREE)

%.o : $(B64DIR)/%.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o : $(BSTRDIR)/%.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: $(ONERING)/%.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o: $(GOLLUM)/%.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

%.o : %.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

server: pemithor boromail faramail
	sudo mv $^ $(TREE)/server/bin
	sudo cp $(ONERING)/getcert.sh $(TREE)/server/bin

pemithor: pemithor.o
	echo Linking: $@
	$(CC) $< -o $@ $(LFLAGS)
	
boromail: boromail.o utils.o boromailutils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o boromailutils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)
	sudo cp boromail $(TREE)/server/bin

faramail: faramail.o utils.o faramailutils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o faramailutils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)

boromailutils: boromailutils.o utils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)
	sudo cp boromailutils $(TREE)/server/bin

faramailutils: faramailutils.o utils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)
	sudo cp faramailutils $(TREE)/server/bin

gollumutils: gollumutils.o utils.o $(BSTROBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) -o $@ $(LFLAGS)
	sudo cp gollumutils $(TREE)/client/bin
	
client: sendmsg recvmsg getcert changepw
	sudo mv $^ $(TREE)/client/bin
	sudo cp $(GOLLUM)/makecsr.sh $(GOLLUM)/genkey.sh $(TREE)/client/bin
	sudo cp imopenssl.cnf $(TREE)/client

getcert: get-cert.o utils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)

changepw: change-pw.o utils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)

sendmsg: send-msg.o utils.o gollumutils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o gollumutils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)
	sudo cp sendmsg $(TREE)/client/bin

recvmsg: recv-msg.o utils.o gollumutils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o gollumutils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)
	sudo cp recvmsg $(TREE)/client/bin

testutils: testutils.o utils.o $(BSTROBJS) $(B64OBJS)
	echo Linking: $@
	$(CC) $< utils.o $(BSTROBJS) $(B64OBJS) -o $@ $(LFLAGS)

%.o: $(GOLLUM)/%.c
	echo Compiling: $<
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f pemithor boromail boromailutils faramail faramailutils gollumutils getcert changepw sendmsg recvmsg testutils *.o

.PHONY : all
.PHONY : install
.PHONY : install-unpriv
.PHONY : install-priv
.PHONY : install-test
.PHONY : gen-certs
.PHONY : clean
