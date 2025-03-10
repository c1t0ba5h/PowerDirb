# 🚀 PowerDirb: Directory Enumeration Tool

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)  
**PowerDirb** is a lightweight PowerShell-based web directory enumeration tool that dynamically fetches wordlists from local and external sources. No need to store or transfer large wordlists — fast and efficient scanning right from the terminal! Powershell based dirb/gobuster/dirbuster!

---

## 🌟 Features
- 🚀 **Real-time wordlist fetching** from both external hosts and your local machine.
- 🔍 **Status-based filtering** (e.g., 200, 405).
- ⚡ **Easy to use** in PowerShell environments.
- 📋 **Color-coded output** (200 in green, 405 in orange, 302 in blue).

---

## 📦 Installation
To install **PowerDirb**, clone the repository:

```bash
git clone https://github.com/c1t0ba5h/PowerDirb.git
cd PowerDirb

```
## 🚀 Usage

```
.\powerdirb.ps1
```
## 🎥 Example Output

```
PS C:\Users\User\Desktop> .\powerdirb.ps1
         ____   _____   ____  
        |    | |  _  | |    |  
    ____|____|_|_|_|_|_|____|____
   /                            \
  /  PowerDirb: Directory Buster \
 /________________________________\
            ________________
          //                \\
         //==================\\
        ||   .-.      .-.     ||
       _||  / o \    / o \    ||_
      /=||  \   /____\   /    ||=\
     |  ||===\__________/=====||  |
      \_||____________________||_/
        ||____________________||
        | \      |   |      / |
       /   \_____|___|_____/   \
      /_________________________\
     /    Scanning Directories   \
    /         from Above!         \
    \_____________________________/
          ( )               ( )
       ( (   ) )         ( (   ) )
      ( ) ( ) ( )       ( ) ( ) ( )
         (_)                 (_)
                          -by c1t0 

[-] Launching PowerDirb Scan...
----------------------------------------------------
[-] What is your target (include: http:// or https://)?: http://127.0.0.1
[-] Where is your wordlist?: https://raw.githubusercontent.com/v0re/dirb/refs/heads/master/wordlists/common.txt
[-] What extension do you want to use (example: .pdf - leave blank for none)?: 
[-] Enter your cookie (leave blank if not applicable): 
[-] Enter your Authorization token (leave blank if not applicable):

Results:
----------------------------------------------------
Found: http://127.0.0.1/administrador -- (SIZE: 251 bytes | response code: 200)                                         
----------------------------------------------------                                                                    

Finished Scan at: 10/12/2024 18:21:34
```
---

## 🛠️ Contributing
We welcome contributions!

## 🙌 Acknowledgments

Inspired by: Tools like DirBuster and gobuster.


