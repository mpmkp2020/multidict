echo "exporting Mutlidict root directory"
export MULTIDICT_ROOT=$(cd "$(dirname "$0")/../.."; pwd;)

cd $MULTIDICT_ROOT
echo "exporting different python versions"
export PYTHON="python$1"

echo "Installing build dependencies"
apt-get update -y
apt-get install -y $PYTHON python3-pip lib$PYTHON-dev git

echo "Update pip"
$PYTHON -m pip install --upgrade pip setuptools wheel
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

if [ CODECOV_TOKEN != '' ]; then
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
 echo "code coverage upload is not intended"
fi
echo "test complete"
