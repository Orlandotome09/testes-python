<h1 align="center">How install and run automated tests</h1>

## Install Python 3.8 in Ubuntu

Install Python and package installer (PIP):

```
sudo apt update
sudo apt install python3
python3 --version
```

## Install Pip (python package manager)

```
sudo apt install -y python3-pip
sudo pip3 install --upgrade pip
```

## Install and active python virtual environment (venv)

```
cd automated_tests_pytest
sudo apt install -y python3-venv
sudo python3.8 -m venv venv
source venv/bin/activate
```

## (OPTIONAL) To DISABLE VENV

```
cd automated_tests_pytest
deactivate
```

## Install Dependencies

```
cd automated_tests_pytest
sudo pip3 install -r requirements.txt
```

## Run Tests

Parameters:

1. **-m** = test tag pytest -m @nameTag
2. **-n** = number of instances to run tests in parallel
3. **-r** = number of retries when a test fails

```
cd automated_tests_pytest
sudo python3 main.py -m done -n 15 -r 2
```

## Run a test individually

Sometimes you want to run a specific test that failed, so you run for example "pytest + FAILED test":

```
cd automated_tests_pytest
pytest step_definitions/test_additional_information_steps.py::test_check_additional_information__export_operation__usd_to_brl__postponed__documents_required
```
