# Assignment 2 - COIT11241 Subject
## Purpose
### Ransome Atack
The purpose of this encryption and decryption scripts are to simulate a ransomware attack scenario for educational and demonstration purposes. In this scenario, a threat actor (the attacker) encrypts a file on the victim's system, rendering the file inaccessible without decryption. The victim is then required to pay a ransom to receive the decryption key necessary to unlock and access their files.
#### File Encryption (encrypt.ps1):
A brute-force attack is demonstrated in a Python script that utilizes a list of commonly used passwords and attempts to gain access to an account by systematically trying each password.
#### File Decryption (decrypt.ps):
he decryption script shows how the encrypted file can be restored to its original state once the correct decryption key is provided. This highlights the critical role of the decryption key in recovering encrypted files.
### Brute-Force Attack
A brute-force attack is demonstrated in a Python script that utilizes a list of commonly used passwords and attempts to gain access to an account by systematically trying each password.
#### brute-force.py
This script uses common 10k passwords file which was obtained from https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10k-most-common.txt

### Security Checking (Test-Host)
test-host.ps1 is a PowerShell script designed to test and report on two critical security features of a host system: <br>
1. Firewall Open Ports <br>
2. Antivirus


The script provides a comprehensive overview of the host’s security posture by combining the results from both checks into a single, easy-to-read report.



