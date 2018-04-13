* Install miniconda (https://repo.continuum.io/miniconda/Miniconda3-latest-Windows-x86_64.exe)

* If you need to set proxy, add following to `%USERPROFILE%/.condarc` file.

~~~~
proxy_servers:
  http: http://your.proxy.server:port
  https: https://your.proxy.server:port
~~~~

## Start and Upgrade

~~~~
C:\tools\python\continuum\miniconda3\Scripts\activate.bat base
conda upgrade conda
conda upgrade --all
~~~~

## Using `conda`

~~~~
conda install package_name [package_name [package_name] ... ]
conda remove package_name
conda update package_name
conda list
conda search search_term
conda create -n env_name list of packages
conda create -n my_env numpy
conda create -n py3 python=3
conda create -n py2 python=2
conda create -n py python=3.3
activate my_env
deactivate
conda env export > environment.yaml
conda env create -f environment.yaml
conda env list
conda env remove -n env_name
~~~~

## Best practices

* Separate environments for `python` 2 and 3

~~~~
conda create -n py2 python=2
conda create -n py3 python=3
~~~~

* Sharing environments

When sharing your code on GitHub, provide `requirements.txt`

~~~~
# generate a requirements file
pip freeze > requirements.txt

# install from it in another environment
pip install -r requirements.txt
~~~~

[1] https://jakevdp.github.io/blog/2016/08/25/conda-myths-and-misconceptions/
