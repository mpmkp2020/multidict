echo "exporting Mutlidict root directory"
echo "${CODECOV_TOKEN}"
export MULTIDICT_ROOT=$(cd "$(dirname "$0")/.."; pwd;)

echo "Installing build dependencies"
yum install gcc gcc-c++ python3-devel wget make enchant-devel -y

cd '/home/multidict_root'
export PATH='/opt/bin':${PATH}
export PYTHON="/opt/_internal/cpython-$1*/bin/python"

echo "Update pip"
$PYTHON -m pip install -U setuptools wheel
if [ $? != "0" ]; then
 echo "Update pip failed"
 exit 1
fi

echo "Install itself"
$PYTHON setup.py install
if [ $? != "0" ]; then
 echo "Install itself failed"
 exit 1
fi

echo "Install dependencies"
$PYTHON -m pip install -r requirements/pytest.txt
if [ $? != "0" ]; then
 echo "Install dependencies failed"
 exit 1
fi

echo "Install pytest-azurepipelines"
$PYTHON -m pip install pytest-azurepipelines
if [ $? != "0" ]; then
 echo "Install pytest-azurepipelines failed"
 exit 1
fi

echo "pytest"
$PYTHON -m pytest tests -vv
if [ $? != "0" ]; then
 echo "pytest failed"
 exit 1
fi

echo "Prepare coverage"
$PYTHON -m coverage xml
if [ $? != "0" ]; then
 echo "Prepare coverage failed"
 exit 1
fi

if [ "${CODECOV_TOKEN}" != '' ]; then
 echo "Install codecov"
 $PYTHON -m pip install codecov
 if [ $? != "0" ]; then
  echo "Install codecov failed"
  exit 1
 fi
 echo "Upload coverage reports"
 $PYTHON -m codecov -f coverage.xml -X gcov
 if [ $? != "0" ]; then
  echo "Upload coverage reports failed"
  exit 1
 fi
else
 echo "codecov token is empty"
fi
echo "test complete"
