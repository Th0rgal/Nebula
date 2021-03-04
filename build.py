#!/usr/bin/env python 
import os

os.system("python3 compile.py build_ext --inplace")
os.system("mv *.so ./output")