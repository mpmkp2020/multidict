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

#conda install --yes --quiet conda-forge-ci-setup=2 conda-build -c conda-forge

# set up the condarc
#setup_conda_rc "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

#source run_conda_forge_build_setup

# make the build number clobber
#make_build_number "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"

#conda build "${RECIPE_ROOT}" -m "${CI_SUPPORT}/${CONFIG}.yaml" \
#    --clobber-file "${CI_SUPPORT}/clobber_${CONFIG}.yaml"

#if [[ "${UPLOAD_PACKAGES}" != "False" ]]; then
#    upload_package "${FEEDSTOCK_ROOT}" "${RECIPE_ROOT}" "${CONFIG_FILE}"
#fi

#touch "${FEEDSTOCK_ROOT}/build_artifacts/conda-forge-build-done-${CONFIG}"
sudo yum update -y
sudo yum install gcc gcc-c++ python3-devel wget -y
cd '/home/conda/feedstock_root'
export CONDA_ENV='travisci'
echo "Installing archiconda"
#${FEEDSTOCK_ROOT}/buildscripts/incremental/setup_conda_environment.sh
export PATH='/opt/conda/bin':${PATH}
echo "Setting up Conda environment"
${FEEDSTOCK_ROOT}/.azure-pipelines/setup_conda_environment.sh
echo "Building multidict"
#source deactivate
${FEEDSTOCK_ROOT}/.azure-pipelines/build.sh
conda install -y flake8
#flake8 numba
#echo "Testing numba"
${FEEDSTOCK_ROOT}/.azure-pipelines/test.h
