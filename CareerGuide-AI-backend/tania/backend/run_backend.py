#!/usr/bin/env python
"""Script to launch the FastAPI backend server."""
import subprocess
import sys
import os

# Ensure we're in the correct directory
os.chdir(os.path.dirname(os.path.abspath(__file__)))

# Run uvicorn
subprocess.run(
    [sys.executable, "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"],
    check=False
)
