## Brute-Force Threat actor script written for COIT11241 Subject
# Assignment 2
# Tevin Herath
# ----------------------------------------------------------------

MY_PASSWORD = "cricket"

with open("10k-most-common.txt") as file:
    for password in file.readlines():
        if password.strip() == MY_PASSWORD:
            print("found password: ", password)
            exit()
print("Password not found..")
