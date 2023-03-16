FROM ubuntu:latest
COPY ./ /root/
RUN apt-get update && \
    apt-get install -y python3 python3-pip vim curl cpanminus make libterm-readline-gnu-perl && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3 && \
    python3 -m pip install --upgrade pip && \
    pip install ipython && \
    cpanm File::HomeDir && \
    cpanm Term::ReadLine
# CMD ["perl", "/root/perl/shell.pl"]
CMD ["/bin/bash"]