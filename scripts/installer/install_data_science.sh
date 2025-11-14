#!/bin/bash
set -euo pipefail

echo "Installing data science tools..."

# Ensure Python is installed
if ! command -v python3 &> /dev/null; then
    ./install-python.sh
fi

# Data manipulation and analysis
pip3 install --user \
    numpy \
    pandas \
    polars \
    dask \
    scipy \
    statsmodels

# Visualization
pip3 install --user \
    matplotlib \
    seaborn \
    plotly \
    altair \
    bokeh

# Machine learning
pip3 install --user \
    scikit-learn \
    xgboost \
    lightgbm \
    catboost

# Data processing
pip3 install --user \
    beautifulsoup4 \
    scrapy \
    requests \
    sqlalchemy \
    pyarrow

# Jupyter and notebooks
pip3 install --user \
    jupyter \
    jupyterlab \
    notebook \
    ipywidgets

echo "Data science setup complete."