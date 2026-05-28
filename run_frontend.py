#!/usr/bin/env python
"""Script to launch the Flutter frontend."""
import subprocess
import sys
import os

# Change to the frontend directory
frontend_dir = r"c:\Users\azili\OneDrive\Desktop\CareerGuide\CareerGuide_AI_frontend"
os.chdir(frontend_dir)

print(f"Current directory: {os.getcwd()}")
print(f"Files: {os.listdir('.')[:5]}")

# Run flutter
subprocess.run(
    ["flutter", "run", "-d", "windows"],
    check=False
)
