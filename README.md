# The Silmailion

Serena "Froggins Baggins" Cheng (stc2137)

William "Samgee Gamgee" Chiu (wnc2105)

Stacy "Pook Took" Tao (syt2111)

Meribuck "Harrison Wang" Brandybuck (hbw2118)


`make install TREE=<name>`

## Notes

If you run into an error with /usr/share/dict/words, please try:

```sudo apt-get install --reinstall wamerican```

Missing libssl-dev:

```fatal error: openssl/ssl.h: No such file or directory```

```sudo apt-get install libssl-dev```

## Assumptions
### Messages
Message files are limited to 1 MB in size. \
Format for messages should begin with a "MAIL FROM:" line (case-insensitive) with the sender name in angle brackets (<,>). Messages that do not follow this format for the first line will be rejected. The following line(s) should be one recipient per line, specified with "RCPT TO:" (case-insensitive) with the recipient name also in angle brackets (<,>). Any lines encountered that do not match this format will stop parsing for recipients.\
Example:
```
mail from:<sender>
rcpt to:<recipient1>
rcpt to:<recipient2>
the following line is not a valid recipient
rcpt to:<recipient2>
but it is still included in the body of the message
```


TODO:
uncomment line "# chown -hR root:root $1/server" in install-priv.sh \
remove line "echo "$cred" >> creds.txt" in install-unpriv.sh