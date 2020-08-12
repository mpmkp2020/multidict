echo "exporting Mutlidict root directory"
export MULTIDICT_ROOT=$(cd "$(dirname "$0")/.."; pwd;)
echo "Installing build dependencies"
yum install gcc gcc-c++ python3-devel wget make enchant-devel -y
cd '/home/multidict_root'
export PATH='/opt/bin':${PATH}
export PYTHON="/opt/_internal/cpython-$1*/bin/python"
echo "pythoncommand"
echo "$PYTHON"
echo "Update pip"
#result=$($PYTHON -m pip install -U setuptools wheel)
$PYTHON -m pip install -U setuptools wheel
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Update pip failed"
 exit 1
fi
echo "Install itself"
$PYTHON setup.py install
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Install itself failed"
 exit 1
fi
echo "Install dependencies"
$PYTHON -m pip install -r requirements/pytest.txt
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Install dependencies failed"
 exit 1
fi
echo "Install pytest-azurepipelines"
$PYTHON -m pip install pytest-azurepipelines
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Install pytest-azurepipelines failed"
 exit 1
fi
echo "pytest"
$PYTHON -m pytest tests -vv
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "pytest failed"
 exit 1
fi
echo "Prepare coverage"
$PYTHON -m coverage xml
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Prepare coverage failed"
 exit 1
fi
echo "Install codecov"
$PYTHON -m pip install codecov
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Install codecov failed"
 exit 1
fi
echo "Upload coverage reports"
$PYTHON -m codecov -f coverage.xml -X gcov
result=$?
echo "result is"
echo "$result"
if [$result != 0]
then
 echo "Upload coverage reports failed"
 exit 1
fi
echo "test complete"
