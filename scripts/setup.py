#!/usr/bin/python3
""" Setup script for the Gurobi optimizer
"""

# This script installs the gurobi module in your local environment, allowing
# you to say 'import gurobipy' from the Python shell.
#
# To install the Gurobi libraries, type 'python setup.py install'.  You
# may need to run this as superuser on a Linux system.
#
# We are grateful to Stuart Mitchell for his help with this script.

from distutils.core import setup, Command #, Extension
from distutils.command.clean import clean
from distutils.command.install import install
import os,sys,shutil

# class GurobiClean(Command):
#    description = "remove the build directory"
#    user_options = []
#    def initialize_options(self):
#        self.cwd = None
#    def finalize_options(self):
#        self.cwd = os.path.dirname(os.path.realpath(__file__))
#    def run(self):
#        assert os.getcwd() == self.cwd, 'Must be run from setup.py directory: %s' % self.cwd
#        build_dir = os.path.join(os.getcwd(), "build")
#        if os.path.exists(build_dir):
#            print('removing %s' % build_dir)
#            shutil.rmtree(build_dir)

class GurobiInstall(install):

    # Calls the default run command, then deletes the build area
    # (equivalent to "setup clean --all").
    def run(self):
        install.run(self)
#        c = GurobiClean(self.distribution)
#        c.finalize_options()
#        c.run()

License = """
    This software is covered by the Gurobi End User License Agreement.
    By completing the Gurobi installation process and using the software,
    you are accepting the terms of this agreement.
"""

# Rather, hardcode path as it is defined by using ENV variables

setup(name="gurobipy",
      version="8.1.1",
      description="""
    The Gurobi optimization engines represent the next generation in
    high-performance optimization software.
    """,
      license = License,
      url="https://www.gurobi.com/",
      author="Gurobi Optimization, LLC",
      packages = ['gurobipy'],
      package_dir={'gurobipy' : '/opt/gurobi/linux64/lib/python3.7_utf32/gurobipy' },
      package_data = {'gurobipy' : ['gurobipy.so'] },
      cmdclass={'install' : GurobiInstall
#                'clean'   : GurobiClean
	       }
      )

