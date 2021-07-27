#!/usr/bin/env python3
from setuptools import setup
setup(
    name = 'wattage',
    version = '0.1.0',
    packages = ['wattaged'],
    entry_points = {
        'console_scripts': [
            'wattage = wattaged.__main__:main'
        ]
    })
