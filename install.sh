git clone https://github.com/mcdappdev/thanks.git
cd thanks
swift build -c release -Xswiftc -static-stdlib
cp -f .build/x86_64-apple-macosx10.10/release/Thanks /usr/local/bin/thanks
cd ../
rm -rf thanks/
