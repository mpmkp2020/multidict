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
result='$PYTHON -m pip install -U setuptools wheel'
echo "$result"
if [$result != 0]
then
 echo "Update pip failed"
 exit 1
fi
echo "Install itself"
result='$PYTHON setup.py install'
if [$result != 0]
then
 echo "Install itself failed"
 exit 1
fi
echo "Install dependencies"
result='$PYTHON -m pip install -r requirements/pytest.txt'
if [$result != 0]
then
 echo "Install dependencies failed"
 exit 1
fi
echo "Install pytest-azurepipelines"
result='$PYTHON -m pip install pytest-azurepipelines'
if [$result != 0]
then
 echo "Install pytest-azurepipelines failed"
 exit 1
fi
echo "pytest"
result='$PYTHON -m pytest tests -vv'
if [$result != 0]
then
 echo "pytest failed"
 exit 1
fi
echo "Prepare coverage"
result='$PYTHON -m coverage xml'
if [$result != 0]
then
 echo "Prepare coverage failed"
 exit 1
fi
echo "Install codecov"
result='$PYTHON -m pip install codecov'
if [$result != 0]
then
 echo "Install codecov failed"
 exit 1
fi
echo "Upload coverage reports"
result='$PYTHON -m codecov -f coverage.xml -X gcov'
if [$result != 0]
then
 echo "Upload coverage reports failed"
 exit 1
fi
echo "test complete"
