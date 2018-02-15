mkdir ndnSIM
cd ndnSIM
git clone https://github.com/named-data-ndnSIM/ns-3-dev.git ns-3
git clone https://github.com/named-data-ndnSIM/pybindgen.git pybindgen
git clone --recursive https://github.com/named-data-ndnSIM/ndnSIM.git ns-3/src/ndnSIM

cd ns-3
./waf configure --enable-examples
./waf

