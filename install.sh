git clone https://github.com/mcdappdev/thanks.git
cd thanks
swift build -c release -Xswiftc -static-stdlib
cp -f .build/release/Executable /usr/local/bin/thanks
cd ../
rm -rf thanks/
