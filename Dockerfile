# Launch it like this:
# docker build -t php-docker .
# docker run --name php-docker --rm -t -i -v "$PWD":/application -w /application php-docker /bin/bash

FROM php:7.1-fpm

RUN apt-get update && \
	apt-get install -y \
		wget git \
		build-essential make \
		zlib1g-dev libzmq3-dev

RUN git clone git://github.com/mkoppanen/php-zmq.git /tmp/php-zmq
WORKDIR /tmp/php-zmq
RUN phpize
RUN ./configure
RUN make && make install

RUN pecl install zmq-beta
RUN docker-php-ext-enable zmq
RUN docker-php-ext-install zip

# install composer
ADD install_composer.sh /install_composer.sh
RUN /install_composer.sh && rm /install_composer.sh
