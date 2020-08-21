echo "exporting Mutlidict root directory"
export MULTIDICT_ROOT=$(cd "$(dirname "$0")/../.."; pwd;)
cd $MULTIDICT_ROOT
echo "list all pythons"
ls /opt/python/

echo "'Use Python $1"
/opt/python/$1/bin/python -m venv .build-venv
 
 echo "Install tools"
 source .build-venv/bin/activate
 pip install -U setuptools wheel
 if [ $? != "0" ]; then
 echo "Update pip failed"
 exit 1
fi
 
 echo "Make wheel"
 #source .build-venv/bin/activate
 export CFLAGS="-Wl,-z"
 export max-page-size="0x10000"
 python setup.py bdist_wheel
 if [ $? != "0" ]; then
 echo "Update pip failed"
 exit 1
fi
 
 echo "Repair wheel"
 auditwheel repair dist/*.whl --wheel-dir wheelhouse/
 if [ $? != "0" ]; then
 echo "Update pip failed"
 exit 1
fi
