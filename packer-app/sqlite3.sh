#!/bin/bash

# Install SQLite and SQLite development package
sudo yum install -y sqlite sqlite-devel

# Download SQLite amalgamation source code
wget "https://www.sqlite.org/2023/sqlite-amalgamation-3420000.zip"

# Unzip the downloaded file
unzip "sqlite-amalgamation-3420000.zip"

# Change into the extracted directory
cd "sqlite-amalgamation-3420000"

# Compile SQLite shell and library
gcc shell.c sqlite3.c -lpthread -ldl -lm -o sqlite3

# Move the compiled binary to /usr/local/bin
sudo mv sqlite3 /usr/local/bin/

# Create a symbolic link to the binary
sudo ln -n /usr/local/bin/sqlite3 /usr/local/bin/sqlite3

# Add /usr/local/bin to the PATH environment variable
export PATH="/usr/local/bin:$PATH"

# Change into the Python-3.9.17 directory
cd "../Python-3.9.17"

# Configure Python with SQLite extensions
./configure --enable-loadable-sqlite-extensions

# Compile and install Python
make
sudo make install

# Optional: Clean up - remove the downloaded zip file and the extracted directory
# rm "../sqlite-amalgamation-3420000.zip"
# rm -r "../sqlite-amalgamation-3420000"
