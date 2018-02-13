cd
mkdir python
cd python
mkdir src
cd src
curl -O https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz
tar xfz Python-2.7.14.tgz
cd Python-2.7.14
mkdir ~/python/python27
./configure -prefix=/home/akshay.raman/python/python27
make
make install
cd
echo "export PATH=$HOME/python/python27/bin" >> .~/bash_profile
source ~/.bash_profile

cd ~/python
curl -O https://files.pythonhosted.org/packages/6c/54/f7e9cea6897636a04e74c3954f0d8335cc38f7d01e27eec98026b049a300/setuptools-38.5.1.zip
tar xvfz setuptools-38.5.1.zip
cd setuptools-38.5.1
python setup.py install
cd ..
curl -O https://files.pythonhosted.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz
tar xzf pip-9.0.1.tar.gz
cd pip-9.0.1
python setup.py install
cd

pip install virtualenv
pip install virtualenvwrapper

