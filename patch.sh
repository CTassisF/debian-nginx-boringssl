#!/bin/bash

sed -i 's,\./configure ,\./configure --with-openssl=/tmp/boringssl ,' nginx-*/debian/rules
sed -i '/\.\/configure /a \\ttouch \/tmp\/boringssl\/\.openssl\/include\/openssl\/ssl\.h' nginx-*/debian/rules
