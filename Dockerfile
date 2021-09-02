FROM docker-remote.binaryrepo-east.arrisi.com/alpine
MAINTAINER dwhitena


# Install Jupyter and gophernotes.
RUN set -x 
# install python and dependencies
RUN apk update
RUN apk add ca-certificates python3 py3-pip su-exec gcc git pkgconfig zeromq-dev musl-dev libffi-dev python3-dev
RUN ln -s /usr/bin/python3.6 /usr/bin/python
## install Go
RUN apk add go
## jupyter notebook
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
### pin down the tornado and ipykernel to compatible versions
RUN pip3 install jupyter notebook pyzmq tornado ipykernel
## install gophernotes

# Add gophernotes
ADD . /go/src/github.com/gopherdata/gophernotes/
WORKDIR /go/src/github.com/gopherdata/gophernotes

RUN GOPATH=/go go install
RUN cp /go/bin/gophernotes /usr/local/bin/
RUN mkdir -p ~/.local/share/jupyter/kernels/gophernotes
RUN cp -r ./kernel/* ~/.local/share/jupyter/kernels/gophernotes
WORKDIR /

# Set GOPATH.
ENV GOPATH /go

EXPOSE 8888
CMD [ "jupyter", "notebook", "--no-browser", "--allow-root", "--ip=0.0.0.0" ]
