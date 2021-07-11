FROM nvcr.io/nvidia/pytorch:21.03-py3
# FROM pytorch/pytorch:1.5.1-cuda10.1-cudnn7-runtime

RUN DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

RUN apt-get update -y && apt-get install -y \
    libgl1-mesa-glx wget curl git tmux imagemagick htop libsndfile1 nodejs npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# for jupyter lab tensorboard
RUN npm install n -g \
    && n stable
RUN apt purge -y nodejs npm
RUN pip install jupyterlab 
# RUN pip install tensorflow==2.1.0 jupyter-tensorboard==0.2.0 tensorflow-estimator==2.1.0 tensorboard==2.1.0
# RUN jupyter labextension install jupyterlab_tensorboard
# RUN jupyter tensorboard enable --system
# RUN jupyter lab clean

# RUN pip install jupyter-vscode-server
# install code server
RUN conda install jupyter-server-proxy -c conda-forge
RUN jupyter labextension install @jupyterlab/server-proxy
RUN pip install jupyter-vscode-proxy

# RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN curl -fOL https://github.com/cdr/code-server/releases/download/v3.4.1/code-server_3.4.1_amd64.deb
RUN dpkg -i code-server_3.4.1_amd64.deb
# RUN systemctl --user enable --now code-server

# install jupyter-desktop-server ( noVNC )
# https://github.com/yuvipanda/jupyter-desktop-server
RUN apt-get update -y && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y dbus-x11 \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/yuvipanda/jupyter-desktop-server.git /opt/install
RUN cd /opt/install && \
   conda env update -n base --file environment.yml

# install display for jupyter-notebook
RUN apt-get update -y && apt-get install -y \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# install python packages
COPY ./Docker/requirements.txt /workspace
# a line bellow is required to install umap-learn
RUN pip install llvmlite --ignore-installed
RUN pip install -r /workspace/requirements.txt


# Since uid and gid will change at entrypoint, anything can be used
ARG USER_ID=1000
ARG GROUP_ID=1000
ENV USER_NAME=jovyan
RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -d /home/${USER_NAME} -m -s /bin/bash -u ${USER_ID} -g ${GROUP_ID} ${USER_NAME}
WORKDIR /home/${USER_NAME}

USER ${USER_NAME}
ENV HOME /home/${USER_NAME}

USER root
# COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

ENV NB_PREFIX /

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["sh","-c", "jupyter lab --notebook-dir=/home/jovyan --ip=0.0.0.0 --no-browser --allow-root --port=8888 --NotebookApp.token='' --NotebookApp.password='' --NotebookApp.allow_origin='*' --NotebookApp.base_url=${NB_PREFIX} --NotebookApp.max_buffer_size=268435456"]
