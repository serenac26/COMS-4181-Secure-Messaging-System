#ifndef __FARAMAILUTILS_H__
#define __FARAMAILUTILS_H__

int login(char *username, char *pw);

int checkmail(char *username);

int changepw(char *username, char *pw);

int addcsr(char *csr, char *username);

int getcert(char *cert, char *username, int *n, int revoke);

#endif