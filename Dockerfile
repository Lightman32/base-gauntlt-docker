FROM ubuntu:18.04
ENV DIRB_WORDLISTS /opt/dirb/wordlists
ENV SSLYZE_PATH /usr/local/bin/sslyze
ENV PATH="/arachni/bin:${PATH}"

# Install Dependencies
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
	git \
  curl \
  libcurl4 \
  libcurl4-openssl-dev \
  wget \
  zlib1g-dev \
  libxml2-dev \
  libxslt1-dev \
  ruby \
  ruby-dev \
  ruby-bundler \
	chrpath libssl-dev libxft-dev \
	libfreetype6 libfreetype6-dev \
	libfontconfig1 libfontconfig1-dev \
	python2.7 python2.7-dev python-pip python-setuptools \
  nmap \
	sqlmap && \
  rm -rf /var/lib/apt/lists/*

# Install PhantomJs
RUN mkdir /tmp/phantomjs \
    && curl -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
           | tar -xj --strip-components=1 -C /tmp/phantomjs \
    && cd /tmp/phantomjs \
    && mv bin/phantomjs /usr/local/bin

# Python Dependencies and sslyze
RUN pip install wheel && \
	pip install sslyze && \
	pip install typing && \
	pip install requests && \
	pip install BeautifulSoup

# Install dirb
RUN \
  wget -q http://downloads.sourceforge.net/project/dirb/dirb/2.22/dirb222.tar.gz && \
  tar -C /opt -xzf dirb222.tar.gz && \
  rm -rf dirb222.tar.gz && \
  mv /opt/dirb222 /opt/dirb && \
  chmod -R +x /opt/dirb && \
  cd /opt/dirb && \
  bash ./configure && \
  make && \
  ln -s `pwd`/dirb /usr/local/bin/dirb

#Install gobuster
RUN \
 cd / && \
 wget -q https://github.com/OJ/gobuster/releases/download/v3.0.1/gobuster-linux-amd64.7z && \
 apt update && \
 apt install -y p7zip-full && \
 7z x gobuster-linux-amd64.7z && \
 mkdir /opt/gobuster && \
 mv /gobuster-linux-amd64/gobuster /opt/gobuster/ && \
 chmod -R +x /opt/gobuster/ && \
 rm gobuster-linux-amd64.7z && \
 rmdir gobuster-linux-amd64 && \
 ln -s /opt/gobuster/gobuster /usr/local/bin/gobuster

# Install Arachni tools
Run \
 wget -q https://github.com/Arachni/arachni/releases/download/v1.5.1/arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
 tar -xzf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
 rm -rf arachni-1.5.1-0.5.12-linux-x86_64.tar.gz && \
 mv arachni-* arachni
 
# Install Garmr
RUN \
  cd /opt && \
  git clone https://github.com/freddyb/Garmr.git && \
  cd Garmr && \
  python setup.py install

# Install Gauntlt from source as released version is bit old
#RUN gem install gauntlt --no-rdoc --no-ri

RUN \
  git clone git://github.com/gauntlt/gauntlt.git && \
  cd gauntlt && \
  bundle && \
  gem build gauntlt.gemspec && \
  gem install gauntlt && \
  rm -rf /gauntlt
