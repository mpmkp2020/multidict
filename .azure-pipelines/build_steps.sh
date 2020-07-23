# PLEASE NOTE: This script has been automatically generated by conda-smithy. Any changes here
# will be lost next time ``conda smithy rerender`` is run. If you would like to make permanent
# changes to this script, consider a proposal to conda-smithy so that other feedstocks can also
# benefit from the improvement.

set -xeuo pipefail
export PYTHONUNBUFFERED=1
export FEEDSTOCK_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
export RECIPE_ROOT="${RECIPE_ROOT:-/home/conda/recipe_root}"
#export CI_SUPPORT="${FEEDSTOCK_ROOT}/.ci_support"
#export CONFIG_FILE="${CI_SUPPORT}/${CONFIG}.yaml"

cat >~/.condarc <<CONDARC
conda-build:
 root-dir: ${FEEDSTOCK_ROOT}/build_artifacts
CONDARC

sudo yum update -y
sudo yum install gcc gcc-c++ python3-devel wget make -y
cd '/home/conda/feedstock_root'
export CONDA_ENV='travisci'
echo "Installing requirement"
pip install -r requirements/lint.txt
make flake8
pip install -e .
export MULTIDICT_NO_EXTENSIONS= 1
make mypy
yum install libenchant-dev
pip install -r requirements/doc-spelling.txt
pip install -r requirements/towncrier.txt
towncrier --yes
pip install -U twine wheel
python setup.py sdist bdist_wheel
twine check dist/*
