import pytest
import argparse
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument("-t", "--marker", "--tags", default="functional")
parser.add_argument("-n", "--numprocesses", default="5")
parser.add_argument("-r", "--reruns", default="4")
args = parser.parse_args()

# Retrieving client secrets
# subprocess.run(['chmod', '+x', './secrets.sh'])
# subprocess.run(['./secrets.sh'])

code = pytest.main(
    [
        f"-m {args.marker}",
        f"-n {args.numprocesses}",
        f"--reruns={args.reruns}",
        "--reruns-delay=5",
        "--cucumberjson=target/cucumber-reports/cucumber.json",
        "--html=target/cucumber-reports/cucumber.html",
    ]
)

exit(code)
