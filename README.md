# PowerDib
# 🚀 PowerDirb: Directory Buster Tool

[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)  
**PowerDirb** is a lightweight PowerShell-based web directory enumeration tool that dynamically fetches wordlists from external sources. No need to store or transfer large wordlists — fast and efficient scanning right from the terminal!

---

## 🌟 Features
- 🚀 Real-time wordlist fetching from external hosts
- 🔍 Supports status-based filtering (e.g., 200, 405)
- ⚡ Simple and easy to use in PowerShell environments
- 📋 Outputs results in color-coded format (200 in green, 405 in orange, 302 in blue)

---

## 📦 Installation
To use **PowerDirb**, clone the repository:

```bash
git clone https://github.com/c1t0ba5h/PowerDib.git
cd PowerDirb

# Example usage
.\powerdirb.ps1

#Example Output
Launching PowerDirb Scan...
Found: https://example.com/admin (200)
Found: https://example.com/login (405)

🛠️ Contributing

We welcome contributions! Please follow these steps:

    Fork the repository.
    Create a new branch: git checkout -b feature-branch-name.
    Commit your changes: git commit -m "Add feature".
    Push to your branch: git push origin feature-branch-name.
    Create a pull request.

🙌 Acknowledgments

    Inspired by tools like DirBuster and gobuster.
    Thanks to the open-source community for the tools and resources that made this project possible.
