FROM crystallang/crystal

# crystalline

RUN \
  apt-get update -y && \
  apt-get install -y wget

RUN \
  wget https://github.com/elbywan/crystalline/releases/latest/download/crystalline_linux.gz -O crystalline.gz && \
  gzip -d crystalline.gz && \
  chmod u+x crystalline && \
  cp crystalline /usr/bin

# ameba

RUN \
  git clone https://github.com/crystal-ameba/ameba && \
  cd ameba && \
  make install

# zsh

RUN \
  apt-get update -y && \
  apt-get install -y zsh curl

ENV SHELL /bin/zsh

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN git clone https://github.com/veelenga/crystal-zsh.git ~/.oh-my-zsh/custom/plugins/crystal

# readline

RUN apt-get install libreadline-dev -y

RUN \
  git clone https://github.com/crystal-lang-tools/scry.git && \
  cd scry && \
  shards build --verbose --release

RUN cp scry/bin/scry /usr/bin

RUN apt-get install python -y