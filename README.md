This allows to play back the testcases recorded with https://github.com/brain-tec/se-builder

## Installation

```bash
pip install robotframework
pip install robotframework-selenium2library
git clone https://github.com/brain-tec/odoo-robot-framework.git
```
To use the database test in demo80.txt you also have to install
```bash
easy_install robotframework-databaselibrary
```


## Run tests

Save the testfile (from SE Builder) in the same directory as the odoo-robot-framework and execute
```bash
pybot -v CONFIG:config_80.py testfile.txt
```
