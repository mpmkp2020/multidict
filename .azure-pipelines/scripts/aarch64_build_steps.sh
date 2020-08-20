echo "exporting Mutlidict root directory"
export MULTIDICT_ROOT=$(cd "$(dirname "$0")/../.."; pwd;)


echo "'Use Python $1"
/opt/python/$1/bin/python -m venv .build-venv
 
 echo "Install tools"
 source .build-venv/bin/activate
 pip install -U setuptools wheel
 
 echo "Make wheel"
 source .build-venv/bin/activate
 python setup.py bdist_wheel
 
 echo "Repair wheel"
 auditwheel repair dist/*.whl --wheel-dir wheelhouse/
